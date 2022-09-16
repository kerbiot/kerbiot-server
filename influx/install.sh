VERSION=2.4.0
ARCHITECTURE=amd64

wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-$VERSION-linux-$ARCHITECTURE.tar.gz
tar xvzf ./influxdb2-client-$VERSION-linux-$ARCHITECTURE.tar.gz
cp influxdb2-client-$VERSION-linux-$ARCHITECTURE/influx influx

rm influxdb2-client-$VERSION-linux-$ARCHITECTURE.tar.gz
rm -rf influxdb2-client-$VERSION-linux-$ARCHITECTURE
