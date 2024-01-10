#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

bashio::log.info "Starting app"

sudo -u 1000:1000 -s /bin/sh -c "/usr/local/bin/entrypoint.sh"
