#!/usr/bin/env bashio
# shellcheck shell=bash

##############
# LAUNCH APP #
##############

# Copy database
cp -n /var/lib/elkarbackup/elkarbackup.sqlite /data

exec nginx & bashio::log.info "Starting nginx..."

bashio::log.info "Starting app..."
/./docker-entrypoint.sh
