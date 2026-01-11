#!/usr/bin/with-contenv bash
set -euo pipefail

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')

bashio::log.info "Initializing data directories with PUID=${PUID} and PGID=${PGID}"

mkdir -p /data/karakeep /data/meilisearch /data/browser-profile /data/wireguard
chown -R "${PUID}:${PGID}" /data/karakeep /data/meilisearch /data/browser-profile

mkdir -p /etc/wireguard
