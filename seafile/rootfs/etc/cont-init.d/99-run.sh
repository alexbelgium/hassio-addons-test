#!/usr/bin/env bashio
DATA_LOCATION="$(bashio::config 'data_location')"

# Chack Seafile dir
bashio::log.info "Making data folder $DATA_LOCATION"

# Make dir
echo "Checking location exists"
mkdir -p "$DATA_LOCATION"

# Make dir
echo "Checking permissions"
chown -R "$(id -u)":"$(id -g)" "$DATA_LOCATION"
chmod -R "$DATA_LOCATION"

# Create symlink
echo "Checking symlink"
ln -fs "$DATA_LOCATION" /shared

# Setup Seafile
echo "Exporting variables"
export SEAFILE_SERVER_LETSENCRYPT="$(bashio::config 'seafile_server_letsencrypt')"
export SEAFILE_SERVER_HOSTNAME="$(bashio::config 'seafile_server_hostname')"
export SEAFILE_ADMIN_EMAIL="$(bashio::config 'seafile_admin_email')"
export SEAFILE_ADMIN_PASSWORD="$(bashio::config 'seafile_admin_password')"
bashio::log.blue "SEAFILE_SERVER_LETSENCRYPT=$SEAFILE_SERVER_LETSENCRYPT"
bashio::log.blue "SEAFILE_SERVER_HOSTNAME=$SEAFILE_SERVER_HOSTNAME"
bashio::log.blue "SEAFILE_ADMIN_EMAIL=$SEAFILE_ADMIN_EMAIL"
bashio::log.blue "SEAFILE_ADMIN_PASSWORD=$SEAFILE_ADMIN_PASSWORD"

# Run Seafile
bashio::log.info "Starting app"
/sbin/my_init -- /scripts/enterpoint.sh
