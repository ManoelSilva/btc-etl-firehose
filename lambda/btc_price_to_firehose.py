import os
import json
import boto3
import requests
from datetime import datetime, timezone, timedelta

from bs4 import BeautifulSoup, Tag


def lambda_handler(event, context):

    url = "https://www.google.com/finance/quote/BTC-USD"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)

    soup = BeautifulSoup(response.text, "html.parser")
    btc_element = soup.find("div", attrs={"data-source": "BTC"})

    if isinstance(btc_element, Tag) and btc_element.has_attr("data-last-price"):
        btc_price = btc_element["data-last-price"]
        print(f"BTC Price: {btc_price}")
    else:
        print("Element with price not found.")

    # Firehose name (should be set as environment variable)
    firehose_name = os.environ.get('FIREHOSE_NAME', 'btc-etl-firehose-stream')
    if not firehose_name:
        print('Environment variable FIREHOSE_NAME not set')
        return {'statusCode': 500, 'body': 'FIREHOSE_NAME not set'}

    # Firehose client
    firehose = boto3.client('firehose')

    # Send data to Firehose
    try:
        data = {
            "timestamp": datetime.now().astimezone(timezone(timedelta(hours=-3))).isoformat(),
            "btc_usd": btc_price
        }
        data_to_send = json.dumps(data)
        response = firehose.put_record(
            DeliveryStreamName=firehose_name,
            Record={
                'Data': data_to_send
            }
        )
        print(
            f'Data sent to Firehose: {data_to_send}\n AWS Response: {response}')
    except Exception as e:
        print(f'Error sending to Firehose: {e}')
        return {'statusCode': 500, 'body': 'Error sending to Firehose'}

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Data sent successfully', 'firehose_data': data})
    }


if __name__ == '__main__':
    lambda_handler(None, None)
