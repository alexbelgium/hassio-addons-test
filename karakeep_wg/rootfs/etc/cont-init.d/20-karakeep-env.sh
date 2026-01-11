#!/usr/bin/with-contenv bash
set -euo pipefail

# shellcheck source=/usr/lib/bashio/bashio.sh
source /usr/lib/bashio/bashio.sh

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')
port=$(bashio::config 'karakeep_port')
nextauth_url=$(bashio::config 'karakeep_nextauth_url')
meili_key=$(bashio::config 'karakeep_meili_master_key')
nextauth_secret=$(bashio::config 'karakeep_nextauth_secret')

if [[ -z "${nextauth_url}" || "${nextauth_url}" == "null" ]]; then
  nextauth_url="http://homeassistant.local:${port}"
fi

env_file=/data/karakeep.env

if [[ ! -f "${env_file}" ]]; then
  touch "${env_file}"
fi

if [[ -z "${meili_key}" || "${meili_key}" == "null" ]]; then
  if ! grep -q '^MEILI_MASTER_KEY=' "${env_file}"; then
    meili_key=$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 64)
    echo "MEILI_MASTER_KEY=${meili_key}" >> "${env_file}"
  else
    meili_key=$(grep '^MEILI_MASTER_KEY=' "${env_file}" | cut -d '=' -f2-)
  fi
else
  if ! grep -q '^MEILI_MASTER_KEY=' "${env_file}"; then
    echo "MEILI_MASTER_KEY=${meili_key}" >> "${env_file}"
  fi
fi

if [[ -z "${nextauth_secret}" || "${nextauth_secret}" == "null" ]]; then
  if ! grep -q '^NEXTAUTH_SECRET=' "${env_file}"; then
    nextauth_secret=$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 64)
    echo "NEXTAUTH_SECRET=${nextauth_secret}" >> "${env_file}"
  else
    nextauth_secret=$(grep '^NEXTAUTH_SECRET=' "${env_file}" | cut -d '=' -f2-)
  fi
else
  if ! grep -q '^NEXTAUTH_SECRET=' "${env_file}"; then
    echo "NEXTAUTH_SECRET=${nextauth_secret}" >> "${env_file}"
  fi
fi

{
  echo "DATA_DIR=/data/karakeep"
  echo "MEILI_ADDR=http://127.0.0.1:7700"
  echo "NEXTAUTH_URL=${nextauth_url}"
} > /data/karakeep.runtime

chown "${PUID}:${PGID}" "${env_file}" /data/karakeep.runtime
chmod 600 "${env_file}"
