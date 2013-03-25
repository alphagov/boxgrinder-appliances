#!/bin/sh
# Affected by this http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=645119
export DEBIAN_FRONTEND=noninteractive 
export DEBIAN_PRIORITY=critical 
apt-add-repository -y ppa:rubiojr/boxgrinder-stable
apt-get update
apt-get -y install rubygems boxgrinder-build
wget --quiet https://gds-boxes.s3.amazonaws.com/resources/guestfs-1.14.2.gem 
gem install --no-ri --no-rdoc guestfs-1.14.2.gem 
gem update boxgrinder-core boxgrinder-build boxgrinder-ubuntu-plugin multidisk-boxgrinder-plugin
rm -f *.gem
echo "Installing Boxgrinder..."
gem install --no-ri --no-rdoc boxgrinder-build boxgrinder-ubuntu-plugin 
apt-get clean
apt-get autoremove --purge
cd /root && git clone https://github.com/alphagov/boxgrinder-appliances
wget --quiet https://gds-boxes.s3.amazonaws.com/resources/VMware-ovftool-3.0.1-801290-lin.x86_64.bundle
chmod +x ./VMware-ovftool-3.0.1-801290-lin.x86_64.bundle
yes | ./VMware-ovftool-3.0.1-801290-lin.x86_64.bundle --required --console
