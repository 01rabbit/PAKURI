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

# Root check
if [ ${EUID:-${UID}} != 0 ]; then
    echo -e "You are not root."
    exit 1
fi

INSTALL_DIR=/usr/share/PAKURI
PLUGINS=/usr/share/PAKURI/plugins

mkdir -p $INSTALL_DIR 2> /dev/null
cp -Rf . $INSTALL_DIR 2> /dev/null

echo -e "${YELLOW}"
echo -e "Installing package dependencies."
echo -e "${NC}"

mkdir -p $PLUGINS
cd $PLUGINS

sudo apt update
sudo apt install -y seclists brutespray xmlstarlet xclip

which openvas-start >& /dev/null
if [ -z $? ];then
    echo -e "OpneVAS Installed"
else
    sudo apt install -y openvas
    openvas-setup|tee openvas.log
fi

echo -e "${LIGHTBLUE}"
echo -e "Installing Plugins."
echo -e "${NC}"

# apt remove -y python3-pip
# apt install -y python3-pip

# git clone https://github.com/Tib3rius/AutoRecon.git
# cd $PLUGINS/AutoRecon && pip3 install -r requirements.txt 2> /dev/null

cd $PLUGINS
systemctl status faraday-server.service > /dev/null
if [ $? ];then
    wget https://github.com/infobyte/faraday/releases/download/v3.10.0/faraday-server_amd64.deb
    sudo apt install -y ./faraday-server_amd64.deb
fi
sudo -u postgres dropdb faraday
sudo -u postgres dropuser faraday_postgresql
faraday-manage initdb|tee faraday.log

chmod +x $INSTALL_DIR/pakuri.sh
chmod +x $INSTALL_DIR/modules/import-faraday.sh

echo -e "${RED}"
echo -e "Installing Plugins."
echo -e "${NC}"
