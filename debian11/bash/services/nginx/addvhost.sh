#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Defaults
#
# OS: debian 11
#
# Grabs $1 (FQDN) $2 (dir) and creates nginx conf default with certbot

FQDN=$1
WWW_DIR=$2
INDEX=$3
CERTBOT_EMAIL=$4

# copy template to nginx path
cp vhost /etc/nginx/sites-available/"$FQDN"

# set server_name
sed -i 's/server_name .*/server_name '"$FQDN"';/' /etc/nginx/sites-available/"$FQDN"

# set web root
# use ~ as deliminator because we are handling paths in variables
sed -i 's~root .*~root '"$WWW_DIR"';~' /etc/nginx/sites-available/"$FQDN"

# set index
sed -i 's/index .*/root '"$INDEX"';/' /etc/nginx/sites-available/"$FQDN"

# create symlink and activate domain
ln -s /etc/nginx/sites-available/"$FQDN" /etc/nginx/sites-enabled/"$FQDN"
service nginx stop
service nginx start

certbot -n --agree-tos --email "$CERTBOT_EMAIL" --authenticator webroot -w "$WWW_DIR" --installer nginx --redirect --hsts --uir --domain "$FQDN"

service nginx reload