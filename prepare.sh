export SWIFT_DIR=/swift
sudo mkdir $SWIFT_DIR
sudo mkdir $SWIFT_DIR/sdv
sudo mkdir /etc/swift
sudo cp swift/etc/account-server.conf-sample /etc/swift/account-server.conf
sudo cp swift/etc/object-server.conf-sample /etc/swift/object-server.conf
sudo cp swift/etc/container-server.conf-sample /etc/swift/container-server.conf
sudo cp swift/etc/proxy-server.conf-sample /etc/swift/proxy-server.conf
sudo cp swift/etc/swift.conf-sample /etc/swift/swift.conf
sudo mkdir /var/run/swift
sudo mkdir /var/cache/swift
