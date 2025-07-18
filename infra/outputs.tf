output "lambda_function_name" {
  value = aws_lambda_function.btc_etl.function_name
}

output "firehose_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.btc_firehose.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.btc_etl_bucket.bucket
}

output "glue_table_name" {
  value = aws_glue_catalog_table.btc_etl_table.name
} 