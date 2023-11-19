#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

if [ -d /homeassistant/addons_config/filebrowser ]; then
    echo "Moving to new location /config/filebrowser"
    mv /homeassistant/addons_config/filebrowser/* /config/
    rm -r /homeassistant/addons_config/filebrowser
fi
