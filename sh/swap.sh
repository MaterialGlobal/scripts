#!/bin/bash
if [ -z $1 ]; then
echo "specify swap size (for example, 4G for 4GB of swap space)"
else
swapoff -a
fallocate -l $1 /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
fi

if [ ! -z $2 ]; then
if [ $2 == yes ]; then
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi
fi
