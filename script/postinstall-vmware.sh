#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
apt-get update
apt-get -u install linux-headers-virtual open-vm-dkms open-vm-tools
