[English Version](README.md)

# BTC ETL Firehose

Este projeto fornece um pipeline ETL (Extract, Transform, Load) para dados de preço do Bitcoin, utilizando serviços da AWS como Lambda e Kinesis Firehose. O pipeline extrai dados de preço do Bitcoin, processa e carrega em um data lake para posterior análise e visualização.

## Estrutura do Projeto

- `infra/`: Scripts de Infraestrutura como Código (IaC) usando Terraform para provisionar recursos AWS.
- `lambda/`: Código da função AWS Lambda para extrair e enviar dados de preço do Bitcoin para o Firehose.
- `notebook/`: Notebooks Jupyter e arquivos relacionados para análise e visualização de dados.

## Funcionalidades

- Extração automatizada de dados de preço do Bitcoin.
- Ingestão de dados em tempo real usando AWS Kinesis Firehose.
- Processamento serverless com AWS Lambda.
- Infraestrutura gerenciada com Terraform.
- Análise e visualização de dados com Jupyter Notebooks e Athena.

## Como Começar

1. **Configuração da Infraestrutura**
   - Navegue até o diretório `infra/` e siga as instruções no `README.md` para provisionar os recursos AWS usando Terraform.

2. **Função Lambda**
   - O diretório `lambda/` contém o código e as dependências da função Lambda que busca os preços do Bitcoin e os envia para o Firehose.

3. **Análise de Dados**
   - Utilize os notebooks no diretório `notebook/` para analisar e visualizar os dados ingeridos.

## Requisitos

- Python 3.8+
- Terraform
- AWS CLI
- Jupyter Notebook

## Licença

Este projeto está licenciado sob a Licença MIT. 