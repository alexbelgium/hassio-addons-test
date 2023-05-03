#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

CONFIG_LOCATION=$(bashio::config 'CONFIG_LOCATION')
bashio::log.info "Config stored in $CONFIG_LOCATION"

mkdir -p "$CONFIG_LOCATION"
chown -R abc:abc "$CONFIG_LOCATION"
chmod -R 755 "$CONFIG_LOCATION"
