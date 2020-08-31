#!/usr/bin/python3
import boto3
from boto3.dynamodb.conditions import Key

session = boto3.session.Session(profile_name="Dev")
ddb = session.resource("dynamodb")
table = ddb.Table("TABLE_NAME")
response = table.query(KeyConditionExpression=Key("id").eq(""))
# Print the element
print(response)
print("The table contains => {} items".format(table.item_count))
