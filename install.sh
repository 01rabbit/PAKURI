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

if [ -f ~/.tmux.conf ];then
    cat tmux.conf >> ~/.tmux.conf
else
    cp tmux.conf ~/.tmux.conf
fi

echo -e "${YELLOW}"
echo -e "Installing package dependencies."
echo -e "${NC}"

sudo apt update
sudo apt install -y seclists brutespray xmlstarlet xclip

which openvas-start >& /dev/null
if [ -z $? ];then
    echo -e "OpneVAS Installed"
else
    sudo apt install -y openvas
    openvas-setup|tee openvas.log
fi

systemctl status faraday-server.service > /dev/null
if [ ! -z $? ];then
    wget https://github.com/infobyte/faraday/releases/download/v3.10.0/faraday-server_amd64.deb
    sudo apt install -y ./faraday-server_amd64.deb
fi
sudo -u postgres dropdb faraday
sudo -u postgres dropuser faraday_postgresql
faraday-manage initdb|tee faraday.log
