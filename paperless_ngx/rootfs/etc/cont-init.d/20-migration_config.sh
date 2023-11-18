#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

slug=paperless_ng

if [ -d /homeassistant/addons_config/$slug ]; then
    echo "Migrating /homeassistant/addons_config/$slug"
    mv /homeassistant/addons_config/$slug/* /config/ || true
    rm /homeassistant/addons_config/$slug
fi

chown -R paperless:paperless /config
