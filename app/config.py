
import boto3
import json
import os

SECRET_KEY = "fdsafasd"
MAX_CONTENT_LENGTH = 16 * 1024 * 1024

aws_region = os.environ.get('AWS_REGION')
session = boto3.session.Session()

secrets_client = session.client(
        service_name='secretsmanager',
        region_name=aws_region,
    )

def get_db_credentials():
    try:
        response = secrets_client.get_secret_value(SecretId="database_credentials")
        if response['ResponseMetadata'] and response['ResponseMetadata']['HTTPStatusCode'] == 200:
            return json.loads(response['SecretString'])
    except Exception as exception:
        print('Error getting secret!')
        print(exception)
    return None

if __name__ == "__main__":
    print(get_db_credentials())
