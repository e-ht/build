#!/usr/bin/env bash

HISTSIZE=0
set +o history

#
# Defaults
#
# OS: debian 11
#
# Grabs $1 (FQDN) and remove site and ssl

FQDN=$1

rm /etc/nginx/sites-available/"$FQDN"
rm /etc/nginx/sites-enabled/"$FQDN"
certbot -n delete --cert-name "$FQDN"

service nginx reload