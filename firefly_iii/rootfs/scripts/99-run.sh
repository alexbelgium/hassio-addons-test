#!/usr/bin/env bashio

########
# Init #
########

# Change data location
echo "Update data location"
mkdir -p /data/fireflyiii

# Backup APP_KEY file
bashio::log.info "Backuping APP_KEY to /config/addons_config/fireflyiii/APP_KEY_BACKUP.txt"
APP_KEY="$(bashio::config 'APP_KEY')"
echo "$APP_KEY" >/config/addons_config/fireflyiii/APP_KEY_BACKUP.txt
if [ ! ${#APP_KEY} = 32 ]; then bashio::exit.nok "Your APP_KEY has ${#APP_KEY} instead of 32 characters"; fi

###################
# Define database #
###################

bashio::log.info "Defining database"
case $(bashio::config 'DB_CONNECTION') in

# Use sqlite
sqlite_internal)
    bashio::log.info "Using built in sqlite"
    # Set variable
    export DB_CONNECTION=sqlite
    # Creating database
    mkdir -p /config/addons_config/fireflyiii/database
    rm -r /var/www/html/storage/database
    ln -snf /config/addons_config/fireflyiii/database /var/www/html/storage
    chown -R www-data:www-data /config/addons_config/fireflyiii
    chown -R www-data:www-data /var/www/html/storage/database
    chmod 775 /var/www/html/storage/database
    touch /var/www/html/storage/database/database.sqlite
    ;;

# Use MariaDB
mariadb_addon)
    bashio::log.info "Using MariaDB addon. Requirements : running MariaDB addon. Detecting values..."
    if ! bashio::services.available 'mysql'; then
        bashio::log.fatal \
            "Local database access should be provided by the MariaDB addon"
        bashio::exit.nok \
            "Please ensure it is installed and started"
    fi

    # Use values
    export DB_CONNECTION=mysql
    export DB_HOST=$(bashio::services "mysql" "host") && bashio::log.blue "DB_HOST=$DB_HOST"
    export DB_PORT=$(bashio::services "mysql" "port") && bashio::log.blue "DB_PORT=$DB_PORT"
    export DB_DATABASE=firefly && bashio::log.blue "DB_DATABASE=$DB_DATABASE"
    export DB_USERNAME=$(bashio::services "mysql" "username") && bashio::log.blue "DB_USERNAME=$DB_USERNAME"
    export DB_PASSWORD=$(bashio::services "mysql" "password") && bashio::log.blue "DB_PASSWORD=$DB_PASSWORD"

    bashio::log.warning "Firefly-iii is using the Maria DB addon"
    bashio::log.warning "Please ensure this is included in your backups"
    bashio::log.warning "Uninstalling the MariaDB addon will remove any data"

    bashio::log.info "Installing mysql to configure the database"
    apt-get update
    apt-get install -yq --no-install-recommends mariadb-client
    apt-get clean
    bashio::log.info "Creating database for Firefly-iii if required"
    mysql \
        -u "${DB_USERNAME}" -p"${DB_PASSWORD}" \
        -h "${DB_HOST}" -P "${DB_PORT}" \
        -e "CREATE DATABASE IF NOT EXISTS \`firefly\` ;"
    ;;

# Use remote
*)
    bashio::log.info "Using remote database. Requirement : filling all addon options fields, and making sure the database already exists"
    for conditions in "DB_HOST" "DB_PORT" "DB_DATABASE" "DB_USERNAME" "DB_PASSWORD"; do
        if ! bashio::config.has_value "$conditions"; then
            bashio::exit.nok "Remote database has been specified but $conditions is not defined in addon options"
        fi
    done
    ;;

esac

# Install database
php artisan migrate --seed
php artisan firefly-iii:upgrade-database

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./usr/local/bin/entrypoint.sh
