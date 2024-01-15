#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

# Cooy data
cp -rn /var/www/filegator/* /config/
mkdir -p /config/private /config/repository
chown -R www-data:www-data /config
chmod -R 777 /config

bashio::log.info "Starting app. Default login : admin/admin123"

# Start app
apache2-foreground docker-php-entrypoint
