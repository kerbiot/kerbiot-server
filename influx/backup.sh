#!/bin/bash
set -e # exit on error

source .env

BACKUP_NAME=$(date +"%Y-%m-%d-%H-%M-%S")

QUERY="from(bucket: \"$INFLUX_BUCKET\") |> range(start: 0, stop: now())"

echo "Backing up" $INFLUX_HOST
eval ./influx query --host 'https://'$INFLUX_HOST -o $INFLUX_ORG -t $INFLUX_TOKEN \'$QUERY\' --raw > $BACKUP_NAME.csv

zip $BACKUP_NAME.zip $BACKUP_NAME.csv 
rm $BACKUP_NAME.csv 

echo "Exported influx data to" $BACKUP_NAME".zip"