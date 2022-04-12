#!/usr/bin/env bashio
# shellcheck shell=bash
# hadolint ignore=SC2155

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./docker-entrypoint.sh
