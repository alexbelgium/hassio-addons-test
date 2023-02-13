#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

#################
# NGINX SETTING #
#################

echo "Adapting for ingress"
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf || true
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf || true

# Move file
mv /etc/nginx/servers/ingress.conf /data/config/nginx/site-confs/

# Correct nginx.conf
if [ -f /data/config/nginx/nginx.conf ]; then
    sed -i "s|error_log /config/log/nginx/error.log|error_log /proc/1/fd/1 error|g" /data/config/nginx/nginx.conf
    sed -i "s|pid /run/nginx.pid|pid /var/run/nginx.pid|g" /data/config/nginx/nginx.conf
    sed -i "1a env HASSIO_TOKEN;" /data/config/nginx/nginx.conf
fi
