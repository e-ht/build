#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Defaults
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

# set hosts shit
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

# create a user
echo "Creating user $HOSTNAME ..."
adduser "$HOSTNAME" --gecos "" --disabled-password

echo "Adding $HOSTNAME to group sudo ..."
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd

echo "Populating $HOSTNAME ssh keys and auth files ..."
# make password available to new user(!)
echo "$PASSWORD" > /home/"$HOSTNAME"/local_auth

# transplant sshkey for new user
mkdir /home/"$HOSTNAME"/.ssh
cp -a /root/.ssh/. /home/"$HOSTNAME"/.ssh/

# make sure new user is the owner of stuff we transplanted
chown -R "$HOSTNAME":"$HOSTNAME" /home/"$HOSTNAME"/.ssh/

# generate rsa key pair and ed25519 key pairs
su "$HOSTNAME" bash -c 'ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/id_rsa -N ""'
su "$HOSTNAME" bash -c 'ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -N ""'

# activate firewall
. services/ufw.sh

# lock down OpenSSH
. services/openssh.sh "$SSH_PORT" "$HOSTNAME"

#read -p "Web dev, etc?? " -n 1 -r
#echo    # (optional) move to a new line
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
#  . web.sh
#  . php.sh
#fi
