#! /bin/bash
# Install script for PAKURI

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
LIGHTBLUE='\033[0;36m'
NC='\033[0m'

INSTALL_DIR=/usr/share/pakuri
PLUGINS=/usr/share/pakuri/plugins

mkdir -p $INSTALL_DIR 2> /dev/null
cp -Rf * $INSTALL_DIR 2> /dev/null

apt update
apt install -y brutespray
apt install -y openvas
apt remove -y python3-pip
apt install -y python3-pip

openvas-setup

cd $PLUGINS
git clone https://github.com/Tib3rius/AutoRecon.git
cd $PLUGINS/AutoRecon && pip3 install -r requirements.txt 2> /dev/null

chmod +x $INSTALL_DIR/pakuri.sh
chmod +x $INSTALL_DIR/modules/import-faraday.sh

ln -s $INSTALL_DIR/pakuri.sh /usr/bin/pakuri