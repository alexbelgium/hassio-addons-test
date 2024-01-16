#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

baseurl=$(bashio::addon.ingress_entry)
baseurl="${baseurl:-empty}"
export baseurl

declare addon_protocol=http
# Generate Ingress configuration
if bashio::config.true 'ssl'; then
    addon_protocol=https
fi

#port=$(bashio::addon.port 80)
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s|%%protocol%%|${addon_protocol}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%port%%|${ingress_port}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%interface%%|${ingress_interface}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%subpath%%|${baseurl}/|g" /etc/nginx/servers/ingress.conf
mkdir -p /var/log/nginx && touch /var/log/nginx/error.log
