#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info "Starting upstream app"
sudo -E -H -u '#102' -g '#102' /entrypoint.sh || sudo -E -H -u netalertx /entrypoint.sh
