#!/usr/bin/with-contenv bashio

###################
# INGRESS SETTING #
###################
declare port
declare certfile
declare ingress_interface
declare ingress_port
declare keyfile

# General values
port=$(bashio::addon.ingress_port)
if [ $port > 1 ]; then 
  # Adapt nginx
  sed -i "s|%%port%%|$port|g" /etc/nginx/servers/ingress.conf
  sed -i "s|%%interface%%|$(bashio::addon.ip_address)|g" /etc/nginx/servers/ingress.conf
  # Removebaseurl
  jq '.reverseProxyPrefix = ""' /config/ubooquity/preferences.json | sponge /config/ubooquity/preferences.json
  # Log
  bashio::log.info "Ingress enabled"
else
  rm /etc/nginx/servers/ingress.conf
fi
