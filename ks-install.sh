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

#Prerequisites
sudo wget https://bootstrap.pypa.io/ez_setup.py --no-check-certificate -O - | python #这行会出一个错误，不过问题不大
sudo apt-get install python-pip
sudo apt-get install python-dev
sudo apt-get install libffi-dev
sudo apt-get install protobuf-compiler
sudo apt-get install memcached
sudo pip install pyeclib
read -p "Prerequisites." var

#Downloading kinetic-swift source
cd ~
git clone https://github.com/swiftstack/kinetic-swift.git
cd kinetic-swift
git submodule update --init
read -p "Downloading kinetic-swift source." var

#Installing from source
sudo python setup.py develop
cd swift
sudo python setup.py develop
cd ../python-swiftclient/
sudo python setup.py install
cd ../kinetic-py/
git submodule init
git submodule update
sudo sh compile_proto.sh 
sudo python setup.py develop
cd ..
read -p "Installing from source." var


#Preparing the environment
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
read -p "Preparing the environment." var

#Give the user that will be running swift read and write permission on the directories:
sudo chmod o+rw $SWIFT_DIR
sudo chmod o+rw $SWIFT_DIR/sdv
sudo chmod o+rw /etc/swift
sudo chmod o+rw /var/run/swift
sudo chmod o+rw /var/cache/swift
read -p "Give the user that will be running swift read and write permission on the directories." var
