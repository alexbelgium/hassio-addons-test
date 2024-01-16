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
    if [ -z "$(ls -A /var/www/filegator/"$folder"/)" ]; then
      cp -rn /var/www/filegator/"$folder"/* /config/"$folder"/ || true
    fi
  fi
done

# Correct configuration.php
rm -r /var/www/filegator/configuration.php
ln -s /config/configuration.php /var/www/filegator/configuration.php
touch /var/log/apache2/error.log

# Correct permissions
chown -R www-data:www-data /var/log
chmod -R 755 /var/log

bashio::log.info "Starting app. Default login : admin/admin123"

# Start app
sudo -u www-data -E /bin/bash -c "apache2-foreground"
