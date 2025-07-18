provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_layer_version" "bs4" {
  filename   = "../lambda/build/layers/layer_beautifulsoup4.zip"
  layer_name = "bs4"
  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_layer_version" "lxml" {
  filename   = "../lambda/build/layers/layer_lxml.zip"
  layer_name = "lxml"
  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_function" "btc_etl" {
  function_name = "btc-etl-firehose"
  role          = var.lab_role_arn
  handler       = "btc_price_to_firehose.lambda_handler"
  runtime       = "python3.12"
  filename      = "../lambda/build/lambda.zip"
  source_code_hash = filebase64sha256("../lambda/build/lambda.zip")
  timeout       = 60
  environment {
    variables = {
      FIREHOSE_STREAM_NAME = aws_kinesis_firehose_delivery_stream.btc_firehose.name
    }
  }
  layers = [
    var.requests_layer_arn,
    aws_lambda_layer_version.bs4.arn,
    aws_lambda_layer_version.lxml.arn
  ]
}

resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "every_minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_every_minute" {
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = "lambda"
  arn       = aws_lambda_function.btc_etl.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.btc_etl.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

resource "aws_glue_catalog_table" "btc_etl_table" {
  name          = "btc_etl_table"
  database_name = "default"
  table_type    = "EXTERNAL_TABLE"
  storage_descriptor {
    columns {
      name = "timestamp"
      type = "string"
    }
    columns {
      name = "btc_usd"
      type = "string"
    }
    location      = "s3://${aws_s3_bucket.btc_etl_bucket.bucket}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "parquet"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }
  }
  parameters = {
    "classification" = "parquet"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "btc_firehose" {
  name        = "btc-etl-firehose-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.lab_role_arn
    bucket_arn         = aws_s3_bucket.btc_etl_bucket.arn
    buffering_size     = 64
    buffering_interval = 300
    compression_format = "UNCOMPRESSED"

    data_format_conversion_configuration {
      enabled = true
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }
      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }
      schema_configuration {
        database_name = "default"
        table_name    = aws_glue_catalog_table.btc_etl_table.name
        role_arn      = var.lab_role_arn
      }
    }
  }
}

resource "aws_s3_bucket" "btc_etl_bucket" {
  bucket = "btc-etl-firehose-bucket-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "random_id" "bucket_id" {
  byte_length = 4
} 