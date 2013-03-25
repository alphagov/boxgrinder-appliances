#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

VBOX_VERSION=$(wget -qO- http://download.virtualbox.org/virtualbox/LATEST.TXT)

# Install the virtualbox guest additions
apt-get update
apt-get -u install linux-headers-virtual dkms

cd /tmp
wget "http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso"
mount -o loop "VBoxGuestAdditions_${VBOX_VERSION}.iso" /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm "VBoxGuestAdditions_$VBOX_VERSION.iso"
