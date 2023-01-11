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
done

###################
# Define database #
###################

bashio::log.info "Defining database"
bashio::log.info "-----------------"

case $(bashio::config 'database') in

    "internal")

        bashio::log.info "Using internal postgresql"
        bashio::log.info ""

        # Settings files & permissions
        ln -s /usr/lib/postgresql/14/bin/postgres /usr/bin || true
        ln -s /usr/lib/postgresql/14/bin/psql /usr/psql || true
        adduser postgres || true
        mkdir -p /data/postgresql
        chown -R postgres /data/postgresql
        chmod -R 777 /data/postgresql

        # Log as postgres
        su - postgres
        /etc/init.d/postgresql start
        psql
        CREATE ROLE root WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'securepassword';
        create database immich;
        create user immich with encrypted password 'immich';
        grant all privileges on database immich to immich;
        \q
        exit

        # Settings parameters
        export DB_USERNAME=immich
        export DB_HOSTNAME=localhost
        export DB_PASSWORD=immich
        export DB_DATABASE_NAME=immich
        export DB_PORT=5432
        ;;

    "external_postgresql")

        bashio::log.info "Using external postgresql"
        bashio::log.info ""

        # Settings parameters
        export DB_USERNAME=$(bashio::config 'DB_USERNAME')
        export DB_HOSTNAME=$(bashio::config 'DB_HOSTNAME')
        export DB_PASSWORD=$(bashio::config 'DB_PASSWORD')
        export DB_DATABASE_NAME=$(bashio::config 'DB_DATABASE_NAME')
        export DB_PORT=$(bashio::config 'DB_PORT')
        export JWT_SECRET="JWT_SECRET"
        ;;

esac

##################
# Starting redis #
##################
exec redis-server & bashio::log.info "Starting redis"

################
# Starting app #
################
bashio::log.info "Starting app"
/./usr/bin/supervisord
