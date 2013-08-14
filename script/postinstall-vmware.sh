#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

echo "deb http://packages.vmware.com/tools/esx/5.1latest/ubuntu precise main" > /etc/apt/sources.list.d/vmware-tools.list
wget http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub -q -O- | apt-key add -

apt-get update
apt-get install -y vmware-tools-esx-nox
