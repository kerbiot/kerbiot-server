# kerbiot-server

Docker compose setup for kerbiot-server.

Contains:

- InfluxDB: Permanent storage for time series
- Grafana: Data visualization and alerting
- Mosquitto: MQTT Broker
- Telegraf: Writes MQTT messages into InfluxDB

## configure

Create an `.env` file from `example.env`.

For Mosquitto username and password use this command:

```sh
docker-compose exec mosquitto mosquitto_passwd -b /mosquitto/config/password.txt user password
```

## start

Start the setup with

```sh
docker-compose up -d
```
