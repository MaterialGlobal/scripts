#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root."
  exit
fi

if [ -z $1 ]; then
  echo "Specify swap size (for example, 4G for 4GB of swap space)."
else
  function cline { tput cuu1;tput el; }
  exec 3>&1 &>/dev/null

  echo "Disabling old swap file" >&3
  swapoff -a
  wait 0.2
  cline >&3; echo "Creating new swap file" >&3
  fallocate -l $1 /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  cline >&3; echo "Enabling the swap file" >&3
  swapon /swapfile
  sleep 0.2

  cline >&3; echo "Adding fstab entry" >&3
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  perl -i -ne 'print if ! $x{$_}++' /etc/stab
  cline >&3; echo "Swap file created and enabled." >&3
fi
