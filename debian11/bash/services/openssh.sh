#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Default OpenSSH
#
# OS: debian 11
# TODO set allowuser, subnet filtering, pork knocking

SSH_PORT=$1
#HOSTNAME=$2 //todo

echo "Securing OpenSSH ..."

CONF_LOCATION=/etc/ssh/sshd_config

echo "Backing up $CONF_LOCATION ..."
cp "$CONF_LOCATION" "$CONF_LOCATION.backup"

echo "Changing port to $SSH_PORT"
sed -i 's/#Port .*/Port '"$SSH_PORT"'/' "$CONF_LOCATION"

echo "Do NOT permit root login ..."
sed -i 's/PermitRootLogin .*/PermitRootLogin no/' $CONF_LOCATION

echo "Rejecting password auth ..."
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication no/' $CONF_LOCATION
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/' $CONF_LOCATION

#echo "PrintMotd ..." # TODO dynamic update-motd
#sed -i 's/PrintMotd .*/PrintMotd yes/' $CONF_LOCATION

# update firewall rules
echo "Updating firewall ... allow $SSH_PORT ..."
ufw allow "$SSH_PORT"