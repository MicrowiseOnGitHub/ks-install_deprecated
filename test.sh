#!/usr/bin/env bash 
set -x #Pring every line of commands out
exec 1> >( tools/outfilter.py -v -o ~/test.log ) 2>&1
echo lalala
echo hahaha
echo huhuhu
echo lululu

if [ ! -d "/hahaha" ]; then
   sudo mkdir /hahaha
fi
sudo chmod 777 /hahaha
