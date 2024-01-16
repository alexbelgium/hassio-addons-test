#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

# Cooy data
for folder in repository private; do
  mkdir -p /config/"$folder"
  chown -R www-data:www-data /config/"$folder"
  chmod -R 755 /config/"$folder"
  cp -rn /var/www/filegator/"$folder"/* /config/"$folder"/
done

# Correct configuration.php
rm -r /var/www/filegator/configuration.php
ln -s /config/configuration.php /var/www/filegator/configuration.php

bashio::log.info "Starting app. Default login : admin/admin123"

# Start app
sudo -u www-data -s /bin/bash -c "apache2-foreground" || true
