#!/bin/bash

# Variables
RED_TEXT=`tput setaf 1`
GREEN_TEXT=`tput setaf 2`
RESET_TEXT=`tput sgr0`
REQUIRED_UBUNTU_VERSION="16.04"
CORE_URL=https://github.com/LIMXTEC/Bitcloud/releases/download/2.0.1.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
CORE_FILE=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
# If you have not used my Masternode install script, please change path to bitcloud-cli & bitcloudd files!
DATA_PATH=/usr/local/bin

echo -n 'Checking Ubuntu Linux Version...'
if [[ `lsb_release -rs` == $REQUIRED_UBUNTU_VERSION ]] # replace 8.04 by the number of release you want
then
	echo "${GREEN_TEXT} 16.04 OK ${RESET_TEXT}"; echo ""
else
	echo "${RED_TEXT} Your Server is not running Ubuntu $REQUIRED_UBUNTU_VERSION, please upgrade to Ubuntu $REQUIRED_UBUNTU_VERSION ! The script will be terminated... ${RESET_TEXT}"; echo ""
	exit
fi

# Stop current running masternode
echo -n 'Stopping Masternode...'
$DATA_PATH/bitcloud-cli stop  > /dev/null 2>&1
sleep 5; echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Download current version, extract and copy
echo -n 'Downloading, extracting and copying files...'
cd ~
wget $CORE_URL > /dev/null 2>&1
tar -xvf $CORE_FILE > /dev/null 2>&1

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
rm -f ~/bitcloudd > /dev/null 2>&1
rm -f ~/bitcloud-cli > /dev/null 2>&1
rm -f ~/bitcloud-tx > /dev/null 2>&1
rm -f ~/bitcloud-qt > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Crontab entry to start bitcloud after server reboot
echo -n 'Creating crontab entry...'
(crontab -l ; echo "@reboot sleep 15 && /usr/local/bin/bitcloudd -daemon -shrinkdebugfile")| crontab -
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Start Masternode running current version
echo -n "Starting Masternode with current version..."
bitcloudd -daemon > /dev/null 2>&1
sleep 10; echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""
echo "${RED_TEXT}Please start you masternode via local desktop wallet debug console -> masternode start-alias YOURMASTERNODEALIAS !${RESET_TEXT}"; echo ""
read -p "After starting your Masternode, press any key to continue... " -n1 -s
echo ""; echo -n 'Stopping Masternode...'
bitcloud-cli stop > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""
sleep 5; echo -n 'Starting Masternode again...'
bitcloudd -daemon > /dev/null 2>&1
echo "${GREEN_TEXT} OK ${RESET_TEXT}"; echo ""

# Show Version and Masternde Info
echo "Getting Masternode Output (60 sec waiting time...)"
sleep 60
bitcloud-cli getinfo