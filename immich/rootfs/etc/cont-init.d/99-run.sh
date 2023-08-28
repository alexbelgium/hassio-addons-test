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

        bashio::log.info "Using external postgresql"
        bashio::log.info ""

        # Check if values exist
        if ! bashio::config.has_value 'DB_USERNAME' && \
            ! bashio::config.has_value 'DB_HOSTNAME' && \
            ! bashio::config.has_value 'DB_PASSWORD' && \
            ! bashio::config.has_value 'DB_DATABASE_NAME' && \
            ! bashio::config.has_value 'JWT_SECRET' && \
            ! bashio::config.has_value 'DB_PORT'
        then
            ! bashio::exit.nok "Please make sure that the following options are set : DB_USERNAME, DB_HOSTNAME, DB_PASSWORD, DB_DATABASE_NAME, DB_PORT"
        fi

        # Settings parameters
        export DB_USERNAME=$(bashio::config 'DB_USERNAME')
        export DB_HOSTNAME=$(bashio::config 'DB_HOSTNAME')
        export DB_PASSWORD=$(bashio::config 'DB_PASSWORD')
        export DB_DATABASE_NAME=$(bashio::config 'DB_DATABASE_NAME')
        export DB_PORT=$(bashio::config 'DB_PORT')
        export JWT_SECRET=$(bashio::config 'JWT_

        # Create database
        echo "CREATE ROLE root WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'securepassword';
             CREATE DATABASE immich; CREATE USER immich WITH ENCRYPTED PASSWORD 'immich';
             GRANT ALL PRIVILEGES ON DATABASE immich to immich;
        \q"> setup_postgres.sql
        chown postgres setup_postgres.sql
        # shellcheck disable=SC2024
        sudo -iu postgres psql < setup_postgres.sql
        rm setup_postgres.sql


##################
# Starting redis #
##################
exec redis-server & bashio::log.info "Starting redis"
