#!/usr/bin/bashio
# shellcheck shell=bash

#################
# NGINX SETTING #
#################
declare ingress_interface
declare ingress_port

ingress_port="$(bashio::addon.ingress_port)"
ingress_interface="$(bashio::addon.ip_address)"
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s|%%ingress_entry%%|${ingress_entry}|g" /etc/nginx/servers/ingress.conf

###############
# ADAPT FILES #
###############
sed -i -e "/SECURE_CROSS_ORIGIN_OPENER_POLICY/d" \
    -e "/# Get vars/a SECURE_CROSS_ORIGIN_OPENER_POLICY = None" /opt/recipes/recipes/settings.py
sed -i -e "/ALLOWED_HOSTS/d" \
    -e "/# Get vars/a ALLOWED_HOSTS=\['\*'\]" /opt/recipes/recipes/settings.py
sed -i -e "/CORS_ORIGIN_ALLOW_ALL/d" \
    -e "/# Get vars/a CORS_ORIGIN_ALLOW_ALL = True" /opt/recipes/recipes/settings.py
