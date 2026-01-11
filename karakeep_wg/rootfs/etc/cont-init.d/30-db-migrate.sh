#!/usr/bin/with-contenv bash
set -euo pipefail

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')

if [[ ! -f /db_migrations/index.js ]]; then
  bashio::log.error "Karakeep migration script not found"
  bashio::exit.nok
fi

bashio::log.info "Running Karakeep database migrations"
exec s6-setuidgid "${PUID}:${PGID}" node /db_migrations/index.js
