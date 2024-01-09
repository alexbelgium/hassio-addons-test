#!/usr/bin/env bashio
# shellcheck shell=bash
set -e

bashio::log.info "---"
bashio::log.info "Starting app"
bashio::log.info "---"

chmod 777 /usr/local/bin/entrypoint.sh
exec /usr/local/bin/entrypoint.sh
