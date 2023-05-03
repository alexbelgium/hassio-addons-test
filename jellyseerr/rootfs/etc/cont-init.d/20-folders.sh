#!/bin/bash

if [ ! -d /config/addons_config/jellyseerr ]; then
    echo "Creating /config/addons_config/jellyseerr"
    mkdir -p /config/addons_config/jellyseerr
fi

if [ -d /config/addons_config/addons_config/jellyseerr ]; then
    echo "Migrating data to /config/addons_config/jellyseerr"
    mv /config/addons_config/addons_config/jellyseerr /config/addons_config/jellyseerr
fi

# shellcheck disable=SC2013
for file in $(grep -Esril "/config/.config/yarn" /usr /etc /defaults); do
    sed -i "s=/config/.config/yarn=/config/addons_config/jellyseerr/yarn=g" "$file"
done
yarn config set global-folder /config/addons_config/jellyseerr/yarn
chown -R abc:abc /config/addons_config/jellyseerr
