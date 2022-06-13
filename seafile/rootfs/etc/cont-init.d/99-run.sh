#!/usr/bin/env bashio
# shellcheck shell=bash
# shellcheck disable=SC2155,SC2016

###################################
# Export all addon options as env #
###################################

bashio::log.info "Setting variables"

# For all keys in options.json
JSONSOURCE="/data/options.json"

# Export keys as env variables
# echo "All addon options were exported as variables"
mapfile -t arr < <(jq -r 'keys[]' "${JSONSOURCE}")

for KEYS in "${arr[@]}"; do
    # export key
    VALUE=$(jq ."$KEYS" "${JSONSOURCE}")
    line="${KEYS}='${VALUE//[\"\']/}'"
    # text
    if bashio::config.false "verbose" || [[ "${KEYS}" == *"PASS"* ]]; then
        bashio::log.blue "${KEYS}=******"
    else
        bashio::log.blue "$line"
    fi
    # Use locally
    export "${KEYS}=${VALUE//[\"\']/}"
    # Export the variable to run scripts
    sed -i "1a export $line" /home/seafile/*.sh 2>/dev/null
    find /opt/seafile -name '*.sh' -print0 | xargs -0 sed -i "1a export $line"
done

#################
# DATA_LOCATION #
#################

bashio::log.info "Setting data location"
DATA_LOCATION=$(bashio::config 'data_location')

echo "Check $DATA_LOCATION folder exists"
mkdir -p "$DATA_LOCATION"

echo "Setting permissions"
chown -R "$(bashio::config 'PUID'):$(bashio::config 'PGID')" "$DATA_LOCATION"
chmod -R 755 "$DATA_LOCATION"

echo "Creating symlink"
ln -sf "$DATA_LOCATION" /shared

export SEAFILE_CONF_DIR="$DATA_LOCATION/conf" && sed -i "1a export SEAFILE_CONF_DIR=$DATA_LOCATION/conf" /home/seafile/*.sh
export SEAFILE_LOGS_DIR="$DATA_LOCATION/logs" && sed -i "1a export SEAFILE_LOGS_DIR=$DATA_LOCATION/logs" /home/seafile/*.sh
export SEAFILE_DATA_DIR="$DATA_LOCATION/seafile-data" && sed -i "1a export SEAFILE_DATA_DIR=$DATA_LOCATION/seafile-data" /home/seafile/*.sh
export SEAFILE_SEAHUB_DIR="$DATA_LOCATION/seahub-data" && sed -i "1a export SEAFILE_SEAHUB_DIR=$DATA_LOCATION/seahub-data" /home/seafile/*.sh
export SEAFILE_SQLITE_DIR="$DATA_LOCATION/sqlite" && sed -i "1a export SEAFILE_SQLITE_DIR=$DATA_LOCATION/sqlite" /home/seafile/*.sh
export DATABASE_DIR="$DATA_LOCATION/db" && sed -i "1a export DATABASE_DIR=$DATA_LOCATION/db" /home/seafile/*.sh

###################
# Define database #
###################

bashio::log.info "Defining database"

case $(bashio::config 'database') in

        # Use sqlite
    sqlite)
        export "SQLITE=1" && sed -i "1a export SQLITE=1" /home/seafile/*.sh
        ;;

        # Use mariadb
    mariadb_addon)
        bashio::log.info "Using MariaDB addon. Requirements : running MariaDB addon. Discovering values..."
        if ! bashio::services.available 'mysql'; then
            bashio::log.fatal \
                "Local database access should be provided by the MariaDB addon"
            bashio::exit.nok \
                "Please ensure it is installed and started"
        fi

        # Use values
        export MYSQL_HOST="$(bashio::services 'mysql' 'host')" && sed -i "1a export MYSQL_HOST=$(bashio::services 'mysql' 'host')" /home/seafile/*.sh
        export MYSQL_PORT="$(bashio::services 'mysql' 'port')" && sed -i "1a export MYSQL_PORT=$(bashio::services 'mysql' 'port')" /home/seafile/*.sh
        export MYSQL_USER="$(bashio::services "mysql" "username")" && sed -i "1a export MYSQL_USER=$(bashio::services 'mysql' 'username')" /home/seafile/*.sh
        export MYSQL_USER_PASSWD="$(bashio::services "mysql" "password")" && sed -i "1a export MYSQL_USER_PASSWD=$(bashio::services 'mysql' 'password')" /home/seafile/*.sh
        export MYSQL_ROOT_PASSWD="$(bashio::services "mysql" "password")" && sed -i "1a export MYSQL_ROOT_PASSWD=$(bashio::services 'mysql' 'password')" /home/seafile/*.sh

        # Mariadb requires a user
        sed -i 's|port=${MYSQL_PORT})|port=${MYSQL_PORT}, user="${MYSQL_USER}")|g' /home/seafile/wait_for_db.sh

        # Mariadb has no root user
        sed -i 's|user="root"|user="${MYSQL_USER}"|g' /home/seafile/clean_db.sh
        sed -i "s|\'root\'|\'${MYSQL_USER}\'|g" /opt/seafile/seafile-server-"$SEAFILE_SERVER_VERSION"/setup-seafile-mysql.sh
        sed -i "s|\'root\'|\'${MYSQL_USER}\'|g" /opt/seafile/seafile-server-"$SEAFILE_SERVER_VERSION"/setup-seafile-mysql.py

        # Informations
        bashio::log.warning "This addon is using the Maria DB addon"
        bashio::log.warning "Please ensure this is included in your backups"
        bashio::log.warning "Uninstalling the MariaDB addon will remove any data"
        ;;
esac

##############
# LAUNCH APP #
##############

bashio::log.info "Starting app"
/./docker_entrypoint.sh
