#!/usr/bin/env bashio
# shellcheck shell=bash
# shellcheck disable=SC2155
set -e

#############
# STRUCTURE #
#############

# Define variables
DATA_LOCATION="$(bashio::config "DATA_LOCATION")"
DATA_LOCATION="${DATA_LOCATION%/}"
DATA_LOCATION_FILE="/data/oldwebtreeshome"

# Create folders
mkdir -p "$DATA_LOCATION"
mkdir -p /config/modules_v4
cp -rn /var2/www/webtrees/data/* "$DATA_LOCATION"/ &>/dev/null || true
cp -rn /var2/www/webtrees/modules_v4/* /config/modules_v4/ &>/dev/null || true

# Check if a migration is needed
if bashio::fs.file_exists "$DATA_LOCATION_FILE"; then
    DATA_LOCATION_CURRENT="$(cat "$DATA_LOCATION_FILE")"
    DATA_LOCATION_CURRENT="${DATA_LOCATION_CURRENT%/}"
elif [[ "$(ls -A /share/webtrees)" ]]; then
    DATA_LOCATION_CURRENT="/share/webtrees"
else
    DATA_LOCATION_CURRENT="$DATA_LOCATION"
fi

# Migrate files
if [[ "$DATA_LOCATION_CURRENT" != "$DATA_LOCATION" ]] && [[ "$(ls -A "$DATA_LOCATION_CURRENT")" ]]; then
    bashio::log.warning "Data location was changed from $DATA_LOCATION_CURRENT to $DATA_LOCATION, migrating files"
    cp -rnf "$DATA_LOCATION_CURRENT"/* "$DATA_LOCATION"/ &>/dev/null || true
    echo "Files moved to $DATA_LOCATION" > "$DATA_LOCATION_CURRENT"/migrated
    mv "$DATA_LOCATION_CURRENT" "${DATA_LOCATION_CURRENT}_migrated"
fi

# Saving data location
echo "... using data folder $DATA_LOCATION"
echo -n "$DATA_LOCATION" > "$PASSWORD_FILE"

# Update permissions
echo "... update permissions"
chown -R www-data:www-data /var2/www/webtrees
chown -R www-data:www-data "$DATA_LOCATION"
chown -R www-data:www-data "/config"

# Creating symlinks
echo "... creating symlinks"
ln -sf "$DATA_LOCATION" /var2/www/webtrees/data
ln -sf "/config/modules_v4" /var2/www/webtrees/modules_v4

###################
# Define database #
###################

bashio::log.info "Defining database"
export DB_TYPE=$(bashio::config 'DB_TYPE')
case $(bashio::config 'DB_TYPE') in

        # Use sqlite
    sqlite)
        bashio::log.info "Using a local sqlite database $DATA_LOCATION/$DB_NAME (Reminder : /config is mapped to /addon_configs/xxx-webtrees from filebrowsers)"
        ;;

    mariadb_addon)
        bashio::log.info "Using MariaDB addon. Requirements : running MariaDB addon. Discovering values..."
        if ! bashio::services.available 'mysql'; then
            bashio::log.fatal \
                "Local database access should be provided by the MariaDB addon"
            bashio::exit.nok \
                "Please ensure it is installed and started"
        fi

        # Use values
        export DB_TYPE=mysql
        export DB_HOST=$(bashio::services "mysql" "host") && bashio::log.blue "DB_HOST=$DB_HOST"
        export DB_PORT=$(bashio::services "mysql" "port") && bashio::log.blue "DB_PORT=$DB_PORT"
        export DB_NAME=webtrees && bashio::log.blue "DB_NAME=$DB_NAME"
        export DB_USER=$(bashio::services "mysql" "username") && bashio::log.blue "DB_USER=$DB_USER"
        export DB_PASS=$(bashio::services "mysql" "password") && bashio::log.blue "DB_PASS=$DB_PASS"

        bashio::log.warning "Webtrees is using the Maria DB addon"
        bashio::log.warning "Please ensure this is included in your backups"
        bashio::log.warning "Uninstalling the MariaDB addon will remove any data"

        # Create database
        # mysql --host="$(bashio::services 'mysql' 'host')" --port="$(bashio::services 'mysql' 'port')" --user="$(bashio::services "mysql" "username")" --password="$(bashio::services "mysql" "password")" -e"CREATE DATABASE IF NOT EXISTS webtrees;"
        ;;

    external)
        bashio::log.info "Using an external database, please populate all required fields in the config.yaml according to documentation"
        ;;

esac


################
# SSL CONFIG   #
################

BASE_URL=$(bashio::config 'BASE_URL')
# Remove the http
BASE_URL="${BASE_URL#*//}"
# Remove the port
BASE_URL="${BASE_URL%%:*}"

bashio::config.require.ssl
if bashio::config.true 'ssl'; then

    #set variables
    CERTFILE=$(bashio::config 'certfile')
    KEYFILE=$(bashio::config 'keyfile')

    #Replace variables
    export SSL_CERT_FILE="/ssl/$CERTFILE"
    export SSL_CERT_KEY_FILE="/ssl/$KEYFILE"

    #Send env variables
    export HTTPS=true
    export SSL=true
    export HTTPS_REDIRECT=true
    BASE_URL_PORT=":$(bashio::addon.port 443)"
    if [[ "$BASE_URL_PORT" == ":443" ]]; then BASE_URL_PORT=""; fi
    BASE_URL_PROTO="https"

    #Communication
    bashio::log.info "Ssl enabled. If webui don't work, check if the port 443 was opened in the addon options, disable ssl or check your certificate paths"

else
    export HTTPS=false
    export SSL=false
    export HTTPS_REDIRECT=false
    BASE_URL_PORT=":$(bashio::addon.port 80)"
    if [[ "$BASE_URL_PORT" == ":80" ]]; then BASE_URL_PORT=""; fi
    BASE_URL_PROTO="http"
fi

BASE_URL="${BASE_URL_PROTO}://${BASE_URL}${BASE_URL_PORT}"
export BASE_URL

# CLOUDFLARE
if bashio::config.true "base_url_portless"; then
    export BASE_URL=$(bashio::config 'BASE_URL')
fi

# Correct base url if needed
echo "... align base url with latest addon value"
if [ -f "$DATA_LOCATION"/config.ini.php ]; then
    echo "Aligning base_url addon config"
    LINE=$(sed -n '/base_url/=' "$DATA_LOCATION"/config.ini.php)
    sed -i "$LINE a base_url=\"$BASE_URL\"" "$DATA_LOCATION"/config.ini.php
    sed -i "$LINE d" "$DATA_LOCATION"/config.ini.php
fi || true

##############
# LAUNCH APP #
##############

bashio::log.info "Launching app, please wait"

###################
# TRUSTED HEADERS #
###################

if bashio::config.has_value "trusted_headers" && [ -f "$DATA_LOCATION"/config.ini.php ]; then
    bashio::log.info "Aligning trusted_headers addon config (use single address, or a range of addresses in CIDR format)"
    sed -i "/trusted_headers/ d" "$DATA_LOCATION"/config.ini.php
    sed -i "1a trusted_headers=\"$(bashio::config 'trusted_headers')\"" "$DATA_LOCATION"/config.ini.php
elif [ -f "$DATA_LOCATION"/config.ini.php ]; then
    bashio::log.info "Aligning trusted_headers addon config with cf-connecting-ip"
    sed -i "/trusted_headers/ d" "$DATA_LOCATION"/config.ini.php
    sed -i "1a trusted_headers=\"cf-connecting-ip\"" "$DATA_LOCATION"/config.ini.php
fi

############
# END INFO #
############

DB_NAME=$(echo "$DB_NAME" | tr -d '"')

bashio::log.info "Data is stored in $DATA_LOCATION"
bashio::log.info "Webui can be accessed at : $BASE_URL"
bashio::log.info "If it is your first boot, the start-up wizard will open"

# Execute main script
echo "python3 /docker-entrypoint.py"
cd /
python3 /docker-entrypoint.py