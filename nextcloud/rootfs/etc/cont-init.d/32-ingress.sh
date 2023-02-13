#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

#################
# NGINX SETTING #
#################

declare ingress_interface
declare ingress_port

echo "Adapting for ingress"
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf || true
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf || true

mv /etc/nginx/servers/ingress.conf /data/config/nginx/site-confs/
