#!/bin/bash
# This script will update your BitCloud (BTDX) Masternode to version 2.0.1.0
# BitCloud Repository : https://github.com/LIMXTEC/Bitcloud
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
##################################################################################

# Variables
CORE_URL=https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.1.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
CORE_FILE=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz

# Stop current running masternode
# If you have not used my Masternode install script, please change path to "bitcloud-cli" file!
/usr/local/bin/bitcloud-cli stop

# Download current version, extract and copy
cd ~
wget $CORE_URL
tar -xvf $CORE_FILE

strip bitcloudd
strip bitcloud-cli
strip bitcloud-tx
yes | cp -iR bitcloudd /usr/local/bin
yes | cp -iR bitcloud-cli /usr/local/bin
yes | cp -iR bitcloud-tx /usr/local/bin

# Delete Files
sleep 5
rm -f $CORE_FILE
rm -f bitcloudd
rm -f bitcloud-cli
rm -f bitcloud-tx

# Start Masternode running current version
bitcloudd

# Show Version and Masternde Info
sleep 120
bitcloud-cli getinfo
