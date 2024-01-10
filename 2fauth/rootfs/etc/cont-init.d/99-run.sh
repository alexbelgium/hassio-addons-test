#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

# Check if APP_KEY is still default, if yes then generate a new one
if [[ "$(bashio::config "APP_KEY")" == *"SomeRandomStringOf32CharsExactl1"* ]]; then
    bashio::log.warning "APP_KEY is still default, a new one will be generated with a backup stored in /config"
    # Generate 32 characters
    APP_KEY="$(openssl rand -base64 32)"
    # Adapt addon options
    bashio::addon.option APP_KEY "$APP_KEY"
    # Backup APP_KEY
    echo "Create backup file"
    file=/config/APP_KEY_"$(date +"%Y-%m-%d")"
    if [ -f "$file" ]; then
        counter=1
        file2="$file_$counter"
        while [ -f "$file2" ]; do
            ((counter++))
            file2="$file_$counter"
        done
    fi
    echo "$APP_KEY" > "$file"
    # Restart addon to make sure new value is considered
    bashio::addon.restart
fi

#####################
# Align permissions #
#####################
(set -o posix; export -p) > /srv/.env
echo "Setting permissions"
chown -R 1000:1000 /config
chmod -R 777 /config

bashio::log.info "Starting app"
