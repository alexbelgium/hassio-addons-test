#!/usr/bin/bashio
# shellcheck shell=bash

#################
# NGINX SETTING #
#################

ingress_port="$(bashio::addon.ingress_port)"
ingress_interface="$(bashio::addon.ip_address)"
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s|%%ingress_entry%%|${ingress_entry}|g" /etc/nginx/servers/ingress.conf
