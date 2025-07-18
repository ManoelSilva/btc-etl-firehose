[Versão em Português](README.pt-br.md)

# BTC ETL Firehose

This project provides an ETL (Extract, Transform, Load) pipeline for Bitcoin price data, utilizing AWS services such as Lambda and Kinesis Firehose. The pipeline extracts Bitcoin price data, processes it, and loads it into a data lake for further analysis and visualization.

## Project Structure

- `infra/`: Infrastructure as Code (IaC) scripts using Terraform to provision AWS resources.
- `lambda/`: AWS Lambda function code for extracting and sending Bitcoin price data to Firehose.
- `notebook/`: Jupyter notebooks and related files for data analysis and visualization.

## Features

- Automated extraction of Bitcoin price data.
- Real-time data ingestion using AWS Kinesis Firehose.
- Serverless processing with AWS Lambda.
- Infrastructure managed with Terraform.
- Data analysis and visualization with Jupyter Notebooks and Athena.

## Getting Started

1. **Infrastructure Setup**
   - Navigate to the `infra/` directory and follow the instructions in the `README.md` to provision AWS resources using Terraform.

2. **Lambda Function**
   - The `lambda/` directory contains the code and dependencies for the Lambda function that fetches Bitcoin prices and sends them to Firehose.

3. **Data Analysis**
   - Use the notebooks in the `notebook/` directory to analyze and visualize the ingested data.

## Requirements

- Python 3.8+
- Terraform
- AWS CLI
- Jupyter Notebook

## License

This project is licensed under the MIT License. 