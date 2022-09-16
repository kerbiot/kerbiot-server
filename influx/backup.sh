#!/bin/bash
set -e # exit on error

source .env

BACKUP_NAME=$(date +"%Y-%m-%d-%H-%M-%S")

echo "Backing up" $INFLUX_HOST
curl -X POST 'https://'$INFLUX_HOST'/api/v2/query?org='$INFLUX_ORG\
    --header 'authorization: Bearer '$INFLUX_TOKEN\
    --header 'content-type: application/json'\
    --data '{"query": "from(bucket: \"'$INFLUX_BUCKET'\")|> range(start: 0, stop: now())", "dialect": {"annotations": ["group","datatype","default"]}}'\
    > $BACKUP_NAME.csv

zip $BACKUP_NAME.zip $BACKUP_NAME.csv 
rm $BACKUP_NAME.csv 

echo "Exported influx data to" $BACKUP_NAME".zip"