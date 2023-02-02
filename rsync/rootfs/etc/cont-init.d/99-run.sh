#!/usr/bin/env bashio
# shellcheck shell=bash

##############
# LAUNCH APP #
##############

exec nginx & bashio::log.info "Starting nginx..."

bashio::log.info "Starting app..."
/./docker-entrypoint.sh
