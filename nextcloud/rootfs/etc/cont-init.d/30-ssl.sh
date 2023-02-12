#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

if bashio::config.true 'use_own_certs'; then

    bashio::log.info "Using referenced ssl certificates..."
    CERTFILE=$(bashio::config 'certfile')
    KEYFILE=$(bashio::config 'keyfile')

    #Check if files exist
    echo "... checking if referenced files exist"
    [ ! -f /ssl/"$CERTFILE" ] && bashio::log.fatal "... use_own_certs is true but certificate /ssl/$CERTFILE not found" && bashio::exit.nok
    [ ! -f /ssl/"$KEYFILE" ] && bashio::log.fatal "... use_own_certs is true but certificate /ssl/$KEYFILE not found" && bashio::exit.nok

    [[ -f /config/keys/cert.key ]] && rm /config/keys/cert.key
    [[ -f /config/keys/cert.crt ]] && rm /config/keys/cert.crt
    cp /ssl/"$CERTFILE" config/keys/cert.crt
    cp /ssl/"$CERTFILE" config/keys/cert.key

fi
