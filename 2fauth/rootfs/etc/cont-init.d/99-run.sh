#!/usr/bin/env bashio
# shellcheck shell=bash
set -e

bashio::log.info "---"
bashio::log.info "Starting app"
bashio::log.info "---"

sudo -u 1000:1000 /usr/local/bin/entrypoint.sh
