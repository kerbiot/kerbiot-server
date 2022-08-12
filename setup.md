# Sensor database

## Initial updates

```sh
sudo apt update && sudo apt upgrade
sudo reboot
```

## Install Docker

Ceck the latest installation guide [here](https://docs.docker.com/engine/install/ubuntu/)

```sh
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
sudo reboot

sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
```

and verify with

```sh
docker version
```

## Setup containers

```sh
mkdir docker
```

Copy over all the files from here inside the `docker` folder.

```sh
sudo docker-compose up -d
```

To set the mosquitto username and password:

```sh
docker-compose exec mosquitto mosquitto_passwd -b /mosquitto/config/password.txt user password
```

To destry everything

```sh
docker compose down
docker system prune
docker volume prune
```

## Disable firewall

```sh
sudo ufw disable
sudo systemctl stop iptables
sudo systemctl disable iptables
sudo systemctl status iptables
sudo iptables --flush
sudo service iptables save
sudo cat /etc/sysconfig/iptables
```

## Nginx

```sh
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl status nginx

sudo unlink /etc/nginx/sites-enabled/default
```

```sh
cd /etc/nginx/sites-available/
sudo nano custom_server.conf
```

Fill file with:

```conf
# this is required to proxy Grafana Live WebSocket connections.
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

upstream grafana {
  server localhost:3000;
}

upstream influx {
  server localhost:8086;
}

server {
  listen 80;
  server_name influx.*;

  client_max_body_size 10G;

  location / {
    proxy_pass http://influx;
  }
}

server {
  listen 80;
  server_name grafana.*;

  location / {
    proxy_set_header Host $http_host;
    proxy_pass http://grafana;
  }

  # Proxy Grafana Live WebSocket connections.
  location /api/live/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header Host $http_host;
    proxy_pass http://grafana;
  }
}
```

```sh
sudo ln -s /etc/nginx/sites-available/custom_server.conf /etc/nginx/sites-enabled/custom_server.conf

sudo service nginx configtest
sudo service nginx restart
```

## HTTPS

```sh
sudo apt install certbot python3-certbot-nginx 
sudo certbot --nginx
sudo service nginx restart
```

[Convert your **static** IPv4 address to hex.](https://www.browserling.com/tools/ip-to-hex)
For example: `123.123.123.123` -> `7b7b7b7b`

This results in the following domain: `*.7b7b7b7b.nip.io`

Request for all sub domains:

- `influx.abcdef.nip.io`,
- `grafana.abcdef.nip.io`

and more if you want to.
