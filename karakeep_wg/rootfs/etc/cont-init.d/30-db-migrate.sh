#!/usr/bin/with-contenv bash
set -euo pipefail

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')

migration_script=""
candidate_paths=(
  /db_migrations/index.js
  /app/db_migrations/index.js
)

for candidate in "${candidate_paths[@]}"; do
  if [[ -f "${candidate}" ]]; then
    migration_script="${candidate}"
    break
  fi
done

if [[ -z "${migration_script}" ]]; then
  bashio::log.warning \
    "Karakeep migration script not found in /db_migrations or /app/db_migrations; skipping migrations"
  exit 0
fi

bashio::log.info "Running Karakeep database migrations"
exec s6-setuidgid "${PUID}:${PGID}" node "${migration_script}"
