#!/bin/bash
# This script will update your BitCloud (BTDX) Masternode to version 2.0.1.0
# BitCloud Repository : https://github.com/LIMXTEC/Bitcloud
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
##################################################################################

# Variables
CORE_URL=https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.1.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
CORE_FILE=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
# If you have not used my Masternode install script, please change path to "bitcloud-cli" file!
DATA_PATH=/usr/local/bin

# Stop current running masternode
echo "*** Stopping Masternode ***"
echo ""
$DATA_PATH/bitcloud-cli stop  > /dev/null 2>&1

# Download current version, extract and copy
echo "*** Downloading, extracting and copying files ***"
echo ""
cd ~
wget $CORE_URL > /dev/null 2>&1
tar -xvf $CORE_FILE > /dev/null 2>&1

strip bitcloudd > /dev/null 2>&1
strip bitcloud-cli > /dev/null 2>&1
strip bitcloud-tx > /dev/null 2>&1
cp -f bitcloudd /usr/local/bin > /dev/null 2>&1
cp -f bitcloud-cli /usr/local/bin > /dev/null 2>&1
cp -f bitcloud-tx /usr/local/bin > /dev/null 2>&1

# Delete Files
echo "*** Deleting unnecessary files ***"
echo ""
sleep 5
rm -f ~/$CORE_FILE > /dev/null 2>&1
rm -f ~/bitcloudd > /dev/null 2>&1
rm -f ~/bitcloud-cli > /dev/null 2>&1
rm -f ~/bitcloud-tx > /dev/null 2>&1
rm -f ~/bitcloud-qt > /dev/null 2>&1

# Start Masternode running current version
echo "*** Starting Masternode with current version ***"
echo ""
bitcloudd -daemon > /dev/null 2>&1
echo "*** Please start you masternode via local desktop wallet debug console -> masternode start-alias YOURMASTERNODEALIAS ***"
echo ""
read -p "After starting your Masternode, press any key to continue... " -n1 -s
bitcloud-cli stop > /dev/null 2>&1
sleep 5
bitcloudd -daemon > /dev/null 2>&1

# Show Version and Masternde Info
echo "*** Masternode Output ***"
echo ""
sleep 60
bitcloud-cli getinfo