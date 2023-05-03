#!/bin/bash

if [ ! -d /config/addons_config/jellyseerr ]; then
    echo "Creating /config/addons_config/jellyseerr"
    mkdir -p /config/addons_config/jellyseerr
fi

cp -rn /app/config/* /config/addons_config/jellyseerr/
