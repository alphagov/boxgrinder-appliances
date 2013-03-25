#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
apt-get clean
apt-get autoremove --purge

# Set up the machine to regenerate its SSH host keys on boot.
touch /etc/ssh/regenerate_host_keys
cat >/etc/rc.local <<EOM
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.

if [ -f /etc/ssh/regenerate_host_keys ]; then
  rm /etc/ssh/ssh_host_*
  /usr/sbin/dpkg-reconfigure openssh-server
  rm /etc/ssh/regenerate_host_keys
fi

exit 0
EOM
chmod +x /etc/rc.local

# Set up some sensible default nameservers
cat >/etc/resolv.conf <<EOM
nameserver 8.8.8.8
nameserver 8.8.4.4
EOM
