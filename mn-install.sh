#!/bin/bash
# This script will install all required stuff to run a Bitcloud (BTDX) Masternode.
# BitSend Repo : https://github.com/LIMXTEC/Bitcloud
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
######################################################################

cd

clear
# declare STRING variable
  STRING1="Make sure you double check before pressing enter! One chance at this only!"
  STRING2="If you found this useful, please consider a small donation to BTDX Donation: "
  STRING3="BNCzeBL1n6DmvCZhKqoZgjZLDJQTUi9TV9"
  STRING4="Updating system and installing required packages."
  STRING5="Switching to Aptitude"
  STRING6="Some optional installs"
  STRING7="Starting your masternode"
  STRING8="Now, you need to finally start your masternode in the following order:"
  STRING9="Go to your windows/mac wallet and modify masternode.conf as required, then restart and from the Control wallet debug console please enter"
  STRING10="masternode start-alias <mymnalias>"
  STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
  STRING12="once completed please return to VPS and press the space bar"
  STRING13=""

# print variable on a screen
  echo $STRING1 

# Ask for important Data for configuring Masternode
  read -e -p "Server IP Address : " ip
  read -e -p "Masternode Private Key (e.g. 7sQ27dGdwwEGrAPHmfghBBfWZnC6K1rDATNvm986dDfsaw3Wws4 # THE KEY YOU GENERATED EARLIER) : " key
  read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
  read -e -p "Install UFW and configure ports? [Y/n] : " UFW

  clear
  echo $STRING2
  echo $STRING13
  echo $STRING3 
  echo $STRING13
  echo $STRING4    
  sleep 10    

# update package and upgrade Ubuntu
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get -y autoremove
  sudo apt-get install wget nano htop -y
  clear
  echo $STRING5
  sudo apt-get -y install aptitude

# Generating Random Passwords
  password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
  password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

  echo $STRING6
  if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    cd ~
    sudo aptitude -y install fail2ban
    sudo service fail2ban restart 
  fi
  if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    sudo apt-get install ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 8329/tcp
    sudo ufw enable -y
  fi


# Create bitcloud.conf
  sudo mkdir .bitcloud
  echo '
  rpcuser='$password'
  rpcpassword='$password2'
  rpcallowip=127.0.0.1
  listen=1
  server=1
  daemon=1
  maxconnections=256
  masternode=1
  masternodeprivkey='$key'
  externalip='$ip'
  ' | sudo -E tee ~/.bitcloud/bitcloud.conf >/dev/null 2>&1
      sudo chmod 0600 ~/.bitcloud/bitcloud.conf

  echo 'bitcloud.conf created'
  sleep 40

  clear
  echo $STRING2
  echo $STRING13
  echo $STRING3 
  echo $STRING13
  echo $STRING4    


# Install Dinero Daemon
  wget https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.0.7/linux.Ubuntu.16.04.LTS_non_static.tar.gz
  sudo tar -xzvf linux.Ubuntu.16.04.LTS_non_static.tar.gz
  sudo rm linux.Ubuntu.16.04.LTS_non_static.tar.gz
  Bitcloud/src/bitcloudd
  clear
 
  sleep 10

# Setting up coin
  clear
  echo $STRING2
  echo $STRING13
  echo $STRING3
  echo $STRING13
  echo $STRING4
  sleep 10

cd

# Starting Bitcloud daemon
  Bitcloud/src/bitcloudd #ist das 2. Starten des Daemons notwendig?

  clear
  echo $STRING2
  echo $STRING13
  echo $STRING3
  echo $STRING13
  echo $STRING4
  sleep 10
  echo $STRING7
  echo $STRING13
  echo $STRING8 
  echo $STRING13
  echo $STRING9 
  echo $STRING13
  echo $STRING10
  echo $STRING13
  echo $STRING11
  echo $STRING13
  echo $STRING12
  sleep 120

  cd
  clear
  echo $STRING2
  echo $STRING13
  echo $STRING3 
  echo $STRING13
  echo $STRING4    

  read -p "(this message will remain for at least 120 seconds) Then press any key to continue... " -n1 -s
  Bitcloud/src/bitcloud-cli getinfo
