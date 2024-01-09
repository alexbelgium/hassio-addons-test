#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info "---"
bashio::log.info "Starting app"
bashio::log.info "---"

/./usr/local/bin/entrypoint.sh