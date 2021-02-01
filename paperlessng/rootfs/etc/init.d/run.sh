#!/usr/bin/env bashio

#Populate variables
bashio::log.info "Setting variables according to configuration"
export PAPERLESS_SECRET_KEY=$(bashio::config 'secretkey')
export PAPERLESS_OCR_LANGUAGE=$(bashio::config 'ocr_lang')
export DEFAULT_USERNAME=$(bashio::config 'username')
export DEFAULT_EMAIL=$(bashio::config 'email')
export DEFAULT_PASSWORD=$(bashio::config 'password')
export PAPERLESS_CONSUMPTION_DIR=$(bashio::config 'consumption_dir')
export PAPERLESS_DATA_DIR=$(bashio::config 'data_dir')
export PAPERLESS_MEDIA_ROOT=$(bashio::config 'media_root')

#Optional variables
if bashio::config.has_value 'UID'; then
bashio::log.info "Setting UID"
    export USERMAP_UID=$(bashio::config 'UID')
fi
if bashio::config.has_value 'GID'; then
bashio::log.info "Setting GID"
    export USERMAP_GID=$(bashio::config 'GID')
fi

#Create directories
bashio::log.info "Creating directories"
mkdir -p $PAPERLESS_CONSUMPTION_DIR
mkdir -p $PAPERLESS_DATA_DIR
mkdir -p $PAPERLESS_MEDIA_ROOT
