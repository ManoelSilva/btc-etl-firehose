# Infraestrutura BTC ETL Firehose

Este diretório contém a infraestrutura como código (IaC) usando Terraform para provisionar:

- AWS Lambda (executando código de `lambda/build/lambda.zip`)
- Agendamento do Lambda a cada minuto (CloudWatch Events)
- Kinesis Data Firehose para ingestão de dados
- Bucket S3 de destino do Firehose

## Pré-requisitos
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configurado com permissões adequadas
- O arquivo `lambda/build/lambda.zip` deve existir antes do `terraform apply`

## Como usar

```sh
cd infra
terraform init
terraform apply
```

Os outputs mostrarão os nomes dos recursos criados. 