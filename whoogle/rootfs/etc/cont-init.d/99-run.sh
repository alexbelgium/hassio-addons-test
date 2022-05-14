#!/usr/bin/env

WHOOGLE_URL_PREFIX="$(bashio::addon.ingress_entry)"
export WHOOGLE_URL_PREFIX

exec misc/tor/start-tor.sh & ./run & echo "Starting NGinx..."

exec nginx
