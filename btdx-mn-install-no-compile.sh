#!/bin/bash

# Variables
RED_TEXT=`tput setaf 1`
GREEN_TEXT=`tput setaf 2`
RESET_TEXT=`tput sgr0`
REQUIRED_UBUNTU_VERSION="16.04"
CORE_URL=https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.1.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
CORE_FILE=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz

# Required Ubuntu Version check
echo -n 'Checking Ubuntu Linux Version...'
if [[ `lsb_release -rs` == $REQUIRED_UBUNTU_VERSION ]] # replace 8.04 by the number of release you want
then
	echo "${GREEN_TEXT} 16.04 OK ${RESET_TEXT}"; echo ""
else
	echo "${RED_TEXT} Your Server is not running Ubuntu $REQUIRED_UBUNTU_VERSION, please upgrade to Ubuntu $REQUIRED_UBUNTU_VERSION ! The script will be terminated... ${RESET_TEXT}"; echo ""
	exit
fi

echo "Make sure you double check before pressing enter! One chance at this only!"; echo ""

# Ask for important Data for configuring Masternode
read -e -p "Server IP Address : " ip
read -e -p "Masternode Private Key (Generate via local Wallet Debug Console -> masternode genkey) : " key
read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
read -e -p "Install UFW and configure ports? [Y/n] : " UFW

# Update, upgrade Ubuntu and install required packages
clear
cd ~ > /dev/null 2>&1
echo -n 'Updating system and installing required packages...'
sudo apt-get -y update > /dev/null 2>&1
sudo apt-get -y upgrade > /dev/null 2>&1
sudo apt-get -y autoremove > /dev/null 2>&1
sudo apt-get install wget nano htop -y > /dev/null 2>&1
sudo apt-get install automake build-essential libtool autotools-dev autoconf pkg-config libssl-dev -y > /dev/null 2>&1
sudo apt-get install libboost-all-dev git npm nodejs nodejs-legacy libminiupnpc-dev redis-server -y > /dev/null 2>&1
sudo apt-get install software-properties-common -y > /dev/null 2>&1
sudo apt-get install libevent-dev -y > /dev/null 2>&1
add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
apt-get update -y > /dev/null 2>&1
apt-get install libdb4.8-dev libdb4.8++-dev -y > /dev/null 2>&1
source ~/.profile > /dev/null 2>&1
apt-get -y install aptitude > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Download Wallet files and copying to /usr/local/bin
echo -n 'Downloading Wallet files and extracting...'
cd > /dev/null 2>&1
mkdir ~/Bitcloud/ > /dev/null 2>&1
wget $CORE_URL > /dev/null 2>&1
tar -xvf $CORE_FILE -C ~/Bitcloud/ > /dev/null 2>&1

cd ~/Bitcloud > /dev/null 2>&1
strip bitcloudd > /dev/null 2>&1
strip bitcloud-cli > /dev/null 2>&1
strip bitcloud-tx > /dev/null 2>&1
cp -f bitcloudd /usr/local/bin > /dev/null 2>&1
cp -f bitcloud-cli /usr/local/bin > /dev/null 2>&1
cp -f bitcloud-tx /usr/local/bin > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Delete Files
echo -n 'Deleting unnecessary files...'
rm -f ~/$CORE_FILE > /dev/null 2>&1
rm -rf ~/Bitcloud/ > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Crontab entry to start bitcloud after server reboot
echo -n 'Creating crontab entry...'
(crontab -l ; echo "@reboot sleep 15 && /usr/local/bin/bitcloudd -daemon -shrinkdebugfile")| crontab -
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Installing, configuring Firewall and Fail2Ban
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
  echo -n 'Installing and starting Fail2Ban...'
  cd ~
  sudo aptitude -y install fail2ban > /dev/null 2>&1
  sudo service fail2ban restart > /dev/null 2>&1
  echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""
fi
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  echo -n 'Installing and starting Firewall...'
  sudo apt-get install ufw > /dev/null 2>&1
  sudo ufw default deny incoming > /dev/null 2>&1
  sudo ufw default allow outgoing > /dev/null 2>&1
  sudo ufw allow ssh > /dev/null 2>&1
  sudo ufw allow 8329/tcp > /dev/null 2>&1
  sudo echo "y" | sudo ufw enable > /dev/null 2>&1
  echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""
fi

# Generating Random Passwords, creating bitcloud.conf file
echo -n 'Creating bitcloud.conf file...'
password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

sudo mkdir ~/.bitcloud > /dev/null 2>&1
sudo touch ~/.bitcloud/bitcloud.conf > /dev/null 2>&1
echo 'rpcuser='$password'
rpcpassword='$password2'
rpcallowip=127.0.0.1
masternodeaddr=127.0.0.1:8329
externalip='$ip'
listen=1
server=1
daemon=1
maxconnections=128
masternode=1
masternodeprivkey='$key'
' | sudo -E tee ~/.bitcloud/bitcloud.conf >/dev/null 2>&1
    sudo chmod 0600 ~/.bitcloud/bitcloud.conf > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Starting Bitcloud daemon
echo -n 'Starting Masternode...'
bitcloudd -daemon > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""
echo "${RED_TEXT}Please start you masternode via local desktop wallet debug console -> masternode start-alias YOURMASTERNODEALIAS !${RESET_TEXT}"; echo ""

# Show Version and Masternde Info
echo "Getting Masternode Output (60 sec waiting time...)"
sleep 60
bitcloud-cli getinfo