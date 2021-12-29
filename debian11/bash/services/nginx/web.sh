#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP WEB NOW OK THANKS"
# TODO set rlimits in nginx conf as well as for base system
# TODO set file paths as variables in head of file?

apt install -y nginx certbot python3-certbot-nginx

# allow traffic to typical ports
ufw allow 80
ufw allow 443

# ensure nolimit is respected in nginx.conf
mkdir -p /etc/systemd/system/nginx.service.d
touch /etc/systemd/system/nginx.service.d/nginx.conf
cat <<CHUNK >> /etc/systemd/system/nginx.service.d/nginx.conf
[Service]
LimitNOFILE=30000
CHUNK
systemctl daemon-reload
systemctl restart nginx.service

#
## Transfer templates
#echo "Transferring templates..."
#mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
#cat templates/nginx.conf > /etc/nginx/nginx.conf
#cat templates/nginx.default > /etc/nginx/sites-available/default
#sed -i 's/server_name _.*/server_name '"$FQDN"';/' /etc/nginx/sites-available/default
#cat templates/index.html > /var/www/html/index.html
#
## Full stop start
#service nginx stop
#service nginx start
#
## Request SSL
## Try for --hsts and --uir even though they aren't currently supported with the nginx module
#echo "Setting up SSL... ?"
##certbot -n --agree-tos --email "$CERTBOT_EMAIL" --authenticator webroot -w /var/www/html/ --installer nginx --redirect --hsts --uir --domain "$FQDN"
#
##service nginx reload