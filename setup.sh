#! /bin/bash
# Setup script for PAKURI

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}"
echo -e " ██▓███        ▄▄▄            ██ ▄█▀      █    ██       ██▀███        ██▓"
echo -e "▓██░  ██▒     ▒████▄          ██▄█▒       ██  ▓██▒     ▓██ ▒ ██▒     ▓██▒"
echo -e "▓██░ ██▓▒     ▒██  ▀█▄       ▓███▄░      ▓██  ▒██░     ▓██ ░▄█ ▒     ▒██▒"
echo -e "▒██▄█▓▒ ▒     ░██▄▄▄▄██      ▓██ █▄      ▓▓█  ░██░     ▒██▀▀█▄       ░██░"
echo -e "▒██▒ ░  ░ ██▓  ▓█   ▓██▒ ██▓ ▒██▒ █▄ ██▓ ▒▒█████▓  ██▓ ░██▓ ▒██▒ ██▓ ░██░"
echo -e "▒▓▒░ ░  ░ ▒▓▒  ▒▒   ▓▒█░ ▒▓▒ ▒ ▒▒ ▓▒ ▒▓▒ ░▒▓▒ ▒ ▒  ▒▓▒ ░ ▒▓ ░▒▓░ ▒▓▒ ░▓  "
echo -e "░▒ ░      ░▒    ▒   ▒▒ ░ ░▒  ░ ░▒ ▒░ ░▒  ░░▒░ ░ ░  ░▒    ░▒ ░ ▒░ ░▒   ▒ ░"
echo -e "░░        ░     ░   ▒    ░   ░ ░░ ░  ░    ░░░ ░ ░  ░     ░░   ░  ░    ▒ ░"
echo -e "           ░        ░  ░  ░  ░  ░     ░     ░       ░     ░       ░   ░  "
echo -e "           ░              ░           ░             ░             ░      "

echo -e "#########################################################################"
echo -e "Starting installation of PAKURI."
echo -e "#########################################################################"
echo -e "${NC}"

# Root check
if [ ${EUID:-${UID}} != 0 ]; then
  echo -e "You are not root."
  exit 1
fi

if [ -f ~/.tmux.conf ]; then
  cat tmux.conf >>~/.tmux.conf
else
  cp tmux.conf ~/.tmux.conf
fi

echo -e "${YELLOW}"
echo -e "Installing package dependencies."
echo -e "${NC}"

sudo apt update
declare -a modules=("dnsrecon" "impacket-scripts" "sslyze" "sslscan" "onesixtyone" 
  "ike-scan" "smbclient" "enum4linux" "nikto" "seclists" "xmlstarlet" "xclip" "gobuster")
for cmd in ${modules[@]}; do
  echo $str
  if command -v $cmd >/dev/null; then
    echo "$cmd installed"
  else
    sudo apt install $cmd -y
  fi
done

# docker
sudo systemctl start docker.service

# codimd
# https://github.com/hackmdio/codimd.git
mkdir codimd
cd codimd/
cat >docker-compose.yml <<EOI
version: "3"
services:
  database:
    image: postgres:11.6-alpine
    environment:
      - POSTGRES_USER=codimd
      - POSTGRES_PASSWORD=codimd_password
      - POSTGRES_DB=codimd
    volumes:
      - "database-data:/var/lib/postgresql/data"
    restart: always
  codimd:
    image: nabo.codimd.dev/hackmdio/hackmd:2.2.0
    environment:
      - CMD_DB_URL=postgres://codimd:codimd_password@database/codimd
      - CMD_USECDN=false
    depends_on:
      - database
    ports:
      - "3000:3000"
    volumes:
      - upload-data:/home/hackmd/app/public/uploads
    restart: always
volumes:
  database-data: {}
  upload-data: {}
EOI
sudo docker-compose up -d

cd ..

# Mattermost
git clone https://github.com/mattermost/mattermost-docker.git
cd mattermost-docker/
cat >docker-compose.yml <<EOI
version: "3"
services:
  db:
    build: db
    read_only: true
    restart: unless-stopped
    volumes:
      - ./volumes/db/var/lib/postgresql/data:/var/lib/postgresql/data
      - /etc/localtime:/etc/localtime:ro
    environment:
      - POSTGRES_USER=mmuser
      - POSTGRES_PASSWORD=mmuser_password
      - POSTGRES_DB=mattermost
  app:
    build:
      context: app
      args:
        - edition=team
    restart: unless-stopped
    volumes:
      - ./volumes/app/mattermost/config:/mattermost/config:rw
      - ./volumes/app/mattermost/data:/mattermost/data:rw
      - ./volumes/app/mattermost/logs:/mattermost/logs:rw
      - ./volumes/app/mattermost/plugins:/mattermost/plugins:rw
      - ./volumes/app/mattermost/client-plugins:/mattermost/client/plugins:rw
      - /etc/localtime:/etc/localtime:ro
    environment:                                                                                                                                                        
      - MM_USERNAME=mmuser                                                                                                                                              
      - MM_PASSWORD=mmuser_password                                                                                                                                     
      - MM_DBNAME=mattermost                                                                                                                                            
      - MM_SQLSETTINGS_DATASOURCE=postgres://mmuser:mmuser_password@db:5432/mattermost?sslmode=disable&connect_timeout=10

  web:
    build: web
    ports:
      - "9080:80"
      - "9443:443"
    read_only: true
    restart: unless-stopped
    volumes:
      - ./volumes/web/cert:/cert:ro
      - /etc/localtime:/etc/localtime:ro
EOI
mkdir -p ./volumes/app/mattermost/{data,logs,config,plugins,client-plugins}
sudo chown -R 2000:2000 ./volumes/app/mattermost/

sudo docker-compose up -d

cd ..

# minio
mkdir minio
cd minio
cat >docker-compose.yml <<EOI
version: '3'

services:
  minio:
    image: minio/minio:latest
    ports:
      - 19000:9000
    volumes:
      - ./data/minio/data:/export
      - ./data/minio/config:/root/.minio
    environment:
      MINIO_ACCESS_KEY: PAKURI_MINIO
      MINIO_SECRET_KEY: pakuri_secret
    command: server /export
  createbuckets:
    image: minio/mc
    depends_on:
      - minio
    entrypoint: >
      /bin/sh -c "
      until (/usr/bin/mc config host add myminio http://minio:9000 PAKURI_MINIO pakuri_secret) do echo '...waiting...' && sleep 1>      /usr/bin/mc mb myminio/mybucket;
      /usr/bin/mc policy download myminio/mybucket;
      exit 0;
      "
EOI

sudo docker-compose up -d

cd ..
