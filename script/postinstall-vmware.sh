#!/bin/sh
#
# This installs VMware Tools from VMware's own Operating System Specific
# Packages (OSP). They allow Guest Customization to modify a VM's hostname
# and static network configuration.
#
# The VMware kernel drivers are currently omitted because they are
# troublesome to build and not essential for provisioning. They could be
# subsequently managed by Puppet, if need be.

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

echo "deb http://packages.vmware.com/tools/esx/5.1latest/ubuntu precise main" > /etc/apt/sources.list.d/vmware-tools.list
wget http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub -q -O- | apt-key add -

apt-get update
apt-get install -y vmware-tools-esx-nox
