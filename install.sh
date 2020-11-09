#!/bin/sh
clear
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Installation of a Oasis Node"
sleep 1
#FREE=`df -k --output=avail "$PWD" | tail -n1`
#if [ $FREE -lt 314572800 ]]; then
#echo "You don't go enought free disk space to sync the blockchain ! (300gb minimum)"
#fi