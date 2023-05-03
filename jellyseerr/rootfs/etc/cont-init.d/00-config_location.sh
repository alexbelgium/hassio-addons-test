#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

CONFIG_LOCATION=$(bashio::config 'CONFIG_LOCATION')
bashio::log.info "Config stored in $CONFIG_LOCATION"
mkdir -p "$CONFIG_LOCATION"
cp -rn /app/config/* "$CONFIG_LOCATION"
rm -r /app/config
ln -s "$CONFIG_LOCATION" /app/config
