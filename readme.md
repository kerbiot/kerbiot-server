# kerbiot-server

Docker compose setup for kerbiot-server.

Contains:

- InfluxDB: Permanent storage for time series
- Grafana: Data visualization and alerting
- Mosquitto: MQTT Broker
- Telegraf: Writes MQTT messages into InfluxDB

## Install

```sh
git clone https://github.com/kerbiot/kerbiot-server.git
cd kerbiot-server
chmod +x ./install.sh
sudo ./install.sh
```
