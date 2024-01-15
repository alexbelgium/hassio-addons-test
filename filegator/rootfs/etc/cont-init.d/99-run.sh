#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

apache2-foreground docker-php-entrypoint
