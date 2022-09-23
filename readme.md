# Kerbiot server

Docker compose setup for Kerbiot.

Contains:

- InfluxDB: Permanent storage for time series data
- Grafana: Data visualization and alerting
- Mosquitto: MQTT Broker
- Telegraf: Writes MQTT messages into InfluxDB

![](.resources/kerbiot-server-diagram.svg)

## Install

```sh
git clone https://github.com/kerbiot/kerbiot-server.git
cd kerbiot-server
chmod +x ./install.sh
sudo ./install.sh
```

### Custom installation

If you want to customize your Kerbiot server:

```sh
chmod +x ./setup.sh
./setup.sh
```

Fill out all the created `.env` file and then run

```sh
./setup.sh
```

again.
