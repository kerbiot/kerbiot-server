#!/bin/bash
echo "Updating system ..."
sudo apt update -y && sudo apt upgrade -y

# --- Docker setup ---
echo "Installing Docker ..."
sudo apt-get install ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

echo "Adding current user to docker group ..."
sudo groupadd docker
sudo usermod -aG docker $USER

# --- Kerbiot setup ---
echo "Setting up Kerbiot ..."
IP=$(curl -s ipinfo.io/ip)
HEX=$(echo $IP | awk -F '.' '{printf "%x", ($1 * 2^24) + ($2 * 2^16) + ($3 * 2^8) + $4}')

PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g')
TOKEN=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g')$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g')

DOMAIN=$HEX'.nip.io'
echo 'DOMAIN='\"$DOMAIN\" > .env

echo 'INFLUXDB_USERNAME='\"kerbiotadmin\" >> .env
echo 'INFLUXDB_PASSWORD='\"$PASSWORD\" >> .env
echo 'INFLUXDB_TOKEN='\"$TOKEN\" >> .env
echo 'INFLUXDB_ORG='\"kerbiot\" >> .env
echo 'INFLUXDB_BUCKET='\"kerbiot\" >> .env

echo 'GRAFANA_USERNAME='\"kerbiotadmin\" >> .env
echo 'GRAFANA_PASSWORD='\"$PASSWORD\" >> .env

MQTT_USER=kerbiot
MQTT_PASSWORD=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g')

echo 'MOSQUITTO_USERNAME='\"kerbiot\" >> .env
echo 'MOSQUITTO_PASSWORD='\"$MQTT_PASSWORD\" >> .env

pushd ./mosquitto/certs
sudo chmod +x ./_generate-certificates.sh
./_generate-certificates.sh $DOMAIN
popd

docker-compose pull
docker-compose up -d
docker-compose exec mosquitto mosquitto_passwd -c -b /mosquitto/config/password.txt $MQTT_USER $MQTT_PASSWORD
docker-compose restart mosquitto

# --- Disable firewall ---
echo "Disabling firewall ..."
sudo ufw disable
sudo systemctl stop iptables
sudo systemctl disable iptables
sudo systemctl status iptables
sudo iptables --flush
sudo service iptables save
sudo cat /etc/sysconfig/iptables

# --- Nginx ---
echo "Installing nginx ..."
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo unlink /etc/nginx/sites-enabled/default
sudo cp ./nginx/custom_server.conf /etc/nginx/sites-available/custom_server.conf
sudo ln -s /etc/nginx/sites-available/custom_server.conf /etc/nginx/sites-enabled/custom_server.conf

sudo service nginx configtest
sudo service nginx restart

# --- Certbot ---
echo "Running certbot ..."
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d '*.'$HEX'.nip.io'
sudo service nginx restart
sudo certbot renew --dry-run