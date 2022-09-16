#!/bin/bash
set -e # exit on error

source .env

BACKUP_NAME=${1%.*} # remove file ending from input
echo $BACKUP_NAME

unzip $BACKUP_NAME.zip

echo "Restoring backup " $BACKUP_NAME "to" $INFLUX_HOST", bucket: " $INFLUX_BUCKET
./influx write --host $INFLUX_HOST --bucket $INFLUX_BUCKET -o $INFLUX_ORG -t $INFLUX_TOKEN --format csv --file $BACKUP_NAME.csv

rm $BACKUP_NAME.csv