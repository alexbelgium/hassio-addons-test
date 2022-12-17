#!/usr/bin/bashio
# shellcheck shell=bash

##################
# ADAPT SETTINGS #
##################

sed -i "/SECURE_CROSS_ORIGIN_OPENER_POLICY/d" /opt/recipes/recipes/settings.py
sed -i "/CsrfViewMiddleware/d" /opt/recipes/recipes/settings.py
sed -i "/CROS_ORIGIN_ALLOW_ALL/a SECURE_CROSS_ORIGIN_OPENER_POLICY = None" /opt/recipes/recipes/settings.py

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

sed -i "1a export SCRIPT_NAME=${ingress_entry}" /etc/cont-init.d/99-run.sh
