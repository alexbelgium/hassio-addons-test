#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

bashio::log.info "Initial username and password are admin. Please change in the administration panel of the webUI after login."

# Implement images modification
if bashio::config.has_value 'PUID'; then sed -i "1a export USERMAP_UID=$(bashio::config 'PUID')" /sbin/docker-entrypoint.sh; fi
if bashio::config.has_value 'PGID'; sed -i "1a export USERMAP_GID=$(bashio::config 'PGID')" /sbin/docker-entrypoint.sh; fi
if bashio::config.has_value 'TZ'; sed -i "1a export PAPERLESS_TIME_ZONE=$(bashio::config 'TZ')" /sbin/docker-entrypoint.sh; fi
if bashio::config.has_value 'OCRLANG'; sed -i "1a export PAPERLESS_OCR_LANGUAGES=$(bashio::config 'OCRLANG')" /sbin/docker-entrypoint.sh; fi
if bashio::config.has_value 'PAPERLESS_OCR_MODE'; sed -i "1a export PAPERLESS_OCR_MODE=$(bashio::config 'PAPERLESS_OCR_MODE')" /sbin/docker-entrypoint.sh; fi

# Force folders
sed -i "1a export PAPERLESS_DATA_DIR=/config/addons_config/paperless_ng" /sbin/docker-entrypoint.sh
sed -i "1a export PAPERLESS_MEDIA_ROOT=/config/addons_config/paperless_ng/media" /sbin/docker-entrypoint.sh
sed -i "1a export PAPERLESS_CONSUMPTION_DIR=/config/addons_config/paperless_ng/consume" /sbin/docker-entrypoint.sh

/./sbin/docker-entrypoint.sh
