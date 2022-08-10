#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root."
  exit
fi

if [ -z $1 ]; then
  echo "Specify swap size (for example, 4G for 4GB of swap space)."
else
  swapoff -a
  fallocate -l $1 /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile

  # add fstab entry
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  # remove duplicate entries
  perl -i -ne 'print if ! $x{$_}++' /etc/stab
fi
