#!/usr/bin/env bash 
set -x #Pring every line of commands out

export SWIFT_DIR=/swift
export KS_SOURCE_DIR=~/kinetic-swift
export LOG_DIR=/var/log/ks_install

if [ ! -d "$LOG_DIR" ]; then
   sudo mkdir $LOG_DIR
fi
if [ -f "$LOG_DIR/ks-inst.log" ]; then
   sudo rm $LOG_DIR/ks-inst.log
fi


sudo chown stack $LOG_DIR
    # Set fd 1 and 2 to write the log file
    exec 1> >( tools/outfilter.py -v -o "$LOG_DIR/ks-inst.log" ) 2>&1

sudo mkdir $SWIFT_DIR
sudo mkdir $SWIFT_DIR/sdv
sudo mkdir /etc/swift
sudo cp $KS_SOURCE_DIR/swift/etc/account-server.conf-sample /etc/swift/account-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/object-server.conf-sample /etc/swift/object-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/container-server.conf-sample /etc/swift/container-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/proxy-server.conf-sample /etc/swift/proxy-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/swift.conf-sample /etc/swift/swift.conf
sudo mkdir /var/run/swift
sudo mkdir /var/cache/swift
