#!/bin/bash
# This script will update your BitCloud (BTDX) Masternode to version 2.0.1.0
# BitCloud Repository : https://github.com/LIMXTEC/Bitcloud
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
##################################################################################

# Stop current running masternode
# If you have not used my Masternode install script, please change path to "bitcloud-cli" file!
/usr/local/bin/bitcloud-cli stop

# Download current version, extract and copy
cd ~
wget https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.1.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
tar -xvf linux.Ubuntu.16.04.LTS_non_static.tar.gz -C ~/Bitcloud/

strip bitcloudd
strip bitcloud-cli
strip bitcloud-tx
yes | cp ~/Bitcloud/bitcloudd /usr/local/bin -iR
yes | cp ~/Bitcloud/bitcloud-cli /usr/local/bin -iR
yes | cp ~/Bitcloud/bitcloud-tx /usr/local/bin -iR

# Delete Files
sleep 5
yes | rm ~/linux.Ubuntu.16.04.LTS_non_static.tar.gz
yes | rm ~/Bitcloud/bitcloudd
yes | rm ~/Bitcloud/bitcloud-cli
yes | rm ~/Bitcloud/bitcloud-tx

# Start Masternode running current version
bitcloudd

# Show Version and Masternde Info
sleep 120
bitcloud-cli getinfo
sleep 5
bitcloud-cli masternode status