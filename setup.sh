#!/bin/bash

set -e # exit on error

# check if .env file exists and load it
if test -f ".env"; then
    source ./.env
    echo "Loaded .env file"
else
    cp example.env .env
    echo "Please fill out the newly created .env file before retrying"
    exit 1
fi

if test -f "./mosquitto/certs/server.crt"; then
    echo "Detected mosquitto server.crt file, not generating certificates"
else
    echo "No mosquitto certificates were detected, generating them ..."
    pushd ./mosquitto/certs
    ./_generate-certificates.sh $DOMAIN
    popd
fi

echo "Updating images ..."
docker-compose pull

echo "Starting containers ..."
docker-compose up -d

echo "Creating mosquitto user $MOSQUITTO_USERNAME"
docker-compose exec mosquitto mosquitto_passwd -c -b /mosquitto/config/password.txt $MOSQUITTO_USERNAME $MOSQUITTO_PASSWORD
docker-compose restart mosquitto