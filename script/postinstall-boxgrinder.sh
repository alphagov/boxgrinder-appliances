#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive 
export DEBIAN_PRIORITY=critical 

# Install boxgrinder and boxgrinder-ubuntu-plugin
apt-add-repository -y ppa:rubiojr/boxgrinder-stable
apt-get update
# libguestfs has a missing dependency on linux-image-extra-*, which provides
# many of the modules for the default ubuntu kernel, including
# virtio_console.ko and friends which are required for sthe supermin appliance
apt-get -y install linux-image-extra-virtual rubygems boxgrinder-build
apt-get clean
apt-get autoremove --purge

# boxgrinder-build is a bit broken on Ubuntu: it relies on a wrapper script
# ("qemu.wrapper") to call out to qemu, which is a bash script with a
# "#!/bin/sh" shebang line. Until my pull request,
#
#   https://github.com/boxgrinder/boxgrinder-build/pull/10 
# 
# is merged, we munge the file to force execution with bash.
sed -i.bak -e 's|#!/bin/sh|#!/bin/bash|' /usr/lib/ruby/vendor_ruby/boxgrinder-build/helpers/qemu.wrapper
chmod +x /usr/lib/ruby/vendor_ruby/boxgrinder-build/helpers/qemu.wrapper

# Install VMware ovftool
wget --quiet https://gds-boxes.s3.amazonaws.com/resources/VMware-ovftool-3.0.1-801290-lin.x86_64.bundle
chmod +x ./VMware-ovftool-3.0.1-801290-lin.x86_64.bundle
yes | ./VMware-ovftool-3.0.1-801290-lin.x86_64.bundle --required --console

# Lastly, check out the GDS appliances
cd /root && git clone https://github.com/alphagov/boxgrinder-appliances
