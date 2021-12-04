#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Do initial setup for fresh system
#
# OS: debian 11


if [ $# -eq 0 ]
  then
    err "ERR | -FQDN -HOSTNAME -SSH_PORT -CERTBOT_EMAIL"
    exit 1
fi

apt-get update && apt-get -y upgrade
apt-get install -y unattended-upgrades build-essential git gnupg

FQDN=$1
HOSTNAME=$2
SSH_PORT=$3
CERTBOT_EMAIL=$4

# generate a password for creating user, etc
PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 63)

# create a user
adduser "$HOSTNAME" --gecos "" --disabled-password
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd

# make password available(!)
echo "$PASSWORD" > /home/"$HOSTNAME"/local_auth

# do ssh key shit here

# generate rsa key pair and ed25519 key pairs
su "$HOSTNAME" bash -c 'ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/id_rsa -N ""'
su "$HOSTNAME" bash -c 'ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -N ""'

echo "SETUP UP SSH NOW OK THANKS"

file=/etc/ssh/sshd_config
sed -i 's/#Port .*/Port '"$SSH_PORT"'/' $file
sed -i 's/#AddressFamily .*/#AddressFamily inet/' $file
sed -i 's/PermitRootLogin .*/PermitRootLogin no/' $file
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication no/' $file