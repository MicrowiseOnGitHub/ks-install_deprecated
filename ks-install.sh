#!/usr/bin/env bash 
set -x #Pring every line of commands out

sudo apt-get update
sudo apt-get upgrade

export KS_INST_DIR=~/ks_inst

if [ ! -d "$KS_INST_DIR" ]; then
   sudo mkdir $KS_INST_DIR
fi
if [ -f "$KS_INST_DIR/ks-inst.log" ]; then
   sudo rm $KS_INST_DIR/ks-inst.log
fi


sudo chown stack $KS_INST_DIR
# Set fd 1 and 2 to write the log file
exec 1> >( tools/outfilter.py -v -o "$KS_INST_DIR/ks-inst.log" ) 2>&1

cd $KS_INST_DIR

#Prerequisites
wget https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

read -p "Microwise: ez_setup and get-pip." var

sudo apt-get install python-dev
sudo apt-get install libffi-dev
sudo apt-get install protobuf-compiler
sudo apt-get install memcached
sudo pip install pyeclib

read -p "Microwise: Prerequisites." var



#Install kinetic-java source
#KS(kinetic-swift) need kinetic-java to communicate with kinetic devices 
cd ~
wget http://219.239.26.14/files/4032000006347FDB/download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz
tar -xf jdk-8u45-linux-x64.tar.gz
export JAVA_HOME=~/jdk1.8.0_45
read -p "Microwise: Installed jdk." var


sudo apt-get install maven
read -p "Microwise: Installed maven." var

cd ~
git clone https://github.com/Seagate/kinetic-java.git
cd kinetic-java
mvn clean package
read -p "Installed kinetic-java." var


#Downloading kinetic-swift source
cd ~
git clone https://github.com/swiftstack/kinetic-swift.git
export KS_SOURCE_DIR=~/kinetic-swift
cd $KS_SOURCE_DIR
git submodule update --init
read -p "Downloaded kinetic-swift source." var

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


#make the DIRs
export SWIFT_DIR=/swift
if [ ! -d "$SWIFT_DIR" ]; then
   sudo mkdir $SWIFT_DIR
fi
sudo chmod 777 $SWIFT_DIR

cd $SWIFT_DIR
if [ ! -d "sdv" ]; then
   sudo mkdir $SWIFT_DIR/sdv
fi
sudo chmod 777 $SWIFT_DIR/sdv

if [ ! -d "/etc/swift" ]; then
   sudo mkdir /etc/swift
fi
sudo chmod 777 /etc/swift

if [ ! -d "/var/run/swift" ]; then
   sudo mkdir /var/run/swift
fi
sudo chmod 777 /var/run/swift

if [ ! -d "/var/cache/swift" ]; then
   sudo mkdir /var/cache/swift
fi
sudo chmod 777 /var/cache/swift


#generating the .conf files
sudo cp $KS_SOURCE_DIR/swift/etc/account-server.conf-sample /etc/swift/account-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/object-server.conf-sample /etc/swift/object-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/container-server.conf-sample /etc/swift/container-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/proxy-server.conf-sample /etc/swift/proxy-server.conf
sudo cp $KS_SOURCE_DIR/swift/etc/swift.conf-sample /etc/swift/swift.conf
read -p "Preparing the .conf files." var

