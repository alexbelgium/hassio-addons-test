#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

export JELLYFIN_TYPE=$(bashio::config 'TYPE')
export TZ=$(bashio::config 'TZ')

yarn start
