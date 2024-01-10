#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

chmod -R 777 /config
chown -R 1000:1000 /config

bashio::log.info "Starting app"
