#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

echo "Setting permissions"
chmod -R 777 /config
chown -R 1000:1000 /config
cp /.env /srv

# Check if APP_KEY is still default, if yes then generate a new one
if [[ "$(bashio::config "APP_KEY")" == "SomeRandomStringOf32CharsExactly" ]]; then
    bashio::log.warning "APP_KEY is still default, a new one will be generated with a backup stored in /config"
    APP_KEY="$(php artisan key:generate)"
    echo "$APP_KEY" > /config/APP_KEY
    bashio::addon.option "APP_KEY" "$APP_KEY"
    bashio::addon.restart
fi

bashio::log.info "Starting app"
