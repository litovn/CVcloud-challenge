import json
import os
import boto3

counter_table = boto3.resource("dynamodb").Table('cloudcv-views')

def lambda_handler(event, context):
    response = counter_table.get_item(Key={'ID':'0'})

    currentVisitors = response["Item"]["visitors"]

    counter_table.update_item(
        Key={'ID':'0'},
        ExpressionAttributeValues={":n": 1},
        UpdateExpression="SET visitors = visitors + :n",
    )

    return {
        "body": currentVisitors,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Content-Type': 'application/json'
    }