#! /bin/bash
# Install script for PAKURI

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

INSTALL_DIR=/usr/share/pakuri
PLUGINS=/usr/share/pakuri/plugins

mkdir -p $INSTALL_DIR 2> /dev/null
cp -Rf . $INSTALL_DIR 2> /dev/null

echo -e "${YELLOW}"
echo -e "Installing package dependencies."
echo -e "${NC}"

apt update
apt install -y brutespray
if [ ! openvas-check-setup >& /dev/null ];then
    apt install -y openvas
    openvas-setup
else
    echo -e "OpneVAS Installed"
fi

echo -e "${LIGHTBLUE}"
echo -e "Installing Plugins."
echo -e "${NC}"

apt remove -y python3-pip
apt install -y python3-pip

mkdir -p $PLUGINS
cd $PLUGINS
git clone https://github.com/Tib3rius/AutoRecon.git
cd $PLUGINS/AutoRecon && pip3 install -r requirements.txt 2> /dev/null

cd $PLUGINS
wget https://github.com/infobyte/faraday/releases/download/v3.10.0/faraday-server_amd64.deb
apt install -y ./faraday-server_amd64.deb
sudo -u postgres dropdb faraday
sudo -u postgres dropuser faraday_postgresql
faraday-manage initdb|tee faraday.log
PASS=`cat faraday.log|grep password:|cut -d " " -f2`

chmod +x $INSTALL_DIR/pakuri.sh
chmod +x $INSTALL_DIR/modules/import-faraday.sh

echo -e "${RED}"
echo -e "Installing Plugins."
echo -e "${NC}"
