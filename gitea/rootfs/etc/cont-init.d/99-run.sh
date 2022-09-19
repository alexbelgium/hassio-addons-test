#!/usr/bin/env bashio
# shellcheck shell=bash

for file in /data/gitea/conf/app.ini /etc/templates/app.ini; do

if [ ! -f "$file" ]; then
continue
fi

##############
# OTHER CONF #
##############

for param in APP_NAME DOMAIN ROOT_URL; do
    sed -i "/$param/d" "$file"
  if bashio::config.has_value "$param"; then
    echo "parameter set : $param=$(bashio::config $param)"
    sed -i "/server/a $param = $(bashio::config $param)" "$file"
  fi
done

##############
# SSL CONFIG #
##############

# Clean values
sed -i "/PROTOCOL/d" "$file"
sed -i "/CERT_FILE/d" "$file"
sed -i "/KEY_FILE/d" "$file"


744

# Add ssl
bashio::config.require.ssl
if bashio::config.true 'ssl'; then
bashio::log.info "ssl is enabled"

sed -i "/server/a PROTOCOL = https" "$file"
sed -i "/server/a CERT_FILE = /ssl/$(bashio::config 'certfile')" "$file"
sed -i "/server/a KEY_FILE = /ssl/$(bashio::config 'keyfile')" "$file"

# Adapt permissions for ssl certificates
chmod 744 /ssl/*
else
sed -i "/server/a PROTOCOL = http" "$file"
fi

done

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./usr/bin/entrypoint
