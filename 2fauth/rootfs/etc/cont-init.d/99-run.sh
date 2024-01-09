#!/usr/bin/env bashio
# shellcheck shell=bash
set -e

bashio::log.info "---"
bashio::log.info "Starting app"
bashio::log.info "---"

bash /usr/local/bin/entrypoint.sh
