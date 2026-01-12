#!/usr/bin/with-contenv bash
set -euo pipefail

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')

migration_script=""

if [[ -f /db_migrations/index.js ]]; then
  migration_script="/db_migrations/index.js"
elif [[ -f /app/db_migrations/index.js ]]; then
  migration_script="/app/db_migrations/index.js"
fi

if [[ -z "${migration_script}" ]]; then
  bashio::log.warning "Karakeep migration script not found; skipping migrations"
  exit 0
fi

bashio::log.info "Running Karakeep database migrations"
exec s6-setuidgid "${PUID}:${PGID}" node "${migration_script}"
