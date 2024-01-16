#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

# Cooy data
for folder in repository private; do
  mkdir -p /config/"$folder"
  chown -R www-data:www-data /config/"$folder"
  chmod -R 755 /config/"$folder"
  if [ -d /var/www/filegator/"$folder" ]; then
    if [ -z "$(ls -A /var/www/filegator/"$folder")" ]; then
      cp -rn /var/www/filegator/"$folder"/* /config/"$folder"/
    fi
  fi
done

# Correct configuration.php
rm -r /var/www/filegator/configuration.php
ln -s /config/configuration.php /var/www/filegator/configuration.php

bashio::log.info "Starting app. Default login : admin/admin123"

# Start app
sudo -u www-data -s /bin/bash -c "apache2-foreground" || true
