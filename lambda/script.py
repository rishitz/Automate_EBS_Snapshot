import json
import boto3 
import time
from botocore.exceptions import ClientError 
def lambda_handler(event, context):
    
    try:
        # EC2 Client
        client = boto3.client('ec2', region_name='us-east-1')
        # Get Volume ID of EBS attached to EC2 Instnace
        response = client.describe_volumes()
        if len(response['Volumes']) > 0:
          for k in response['Volumes']:
              print("EBS Volume ID : ",k['VolumeId'], " of EC2 Instance : ", k['Attachments'][0]['InstanceId'])
              try:
                  # Create a Snapshot of Volume
                  responsesnapsnot = client.create_snapshot(VolumeId= k['VolumeId'])
                  print("Snapshot Created with ID : ", responsesnapsnot['SnapshotId'])
              except Exception as e:
                  print("some error :", e)
        return {
                'statusCode': 200,
                'body': json.dumps("sucess")
                }
    except ClientError as e:
            print("Detailed error: ",e)
            return {
                    'statusCode': 500,
                    'body': json.dumps("error")
               
                    }
    except Exception as e:
            print("Detailed error: ",e)
            return {
                    'statusCode': 500,
                    'body': json.dumps("error")
               
                    }