#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

PUID=$(bashio::config "PUID")
PGID=$(bashio::config "PGID")

# Check current version
if [ -f /data/config/www/nextcloud/config/config.php ]; then
    datadirectory="$(sed -n "s|.*datadirectory' => '*\(.*[^ ]\) *',.*|\1|p" /data/config/www/nextcloud/config/config.php)"
else
    datadirectory=/share/nextcloud
fi

echo "Checking permissions"
mkdir -p /data/config
mkdir -p "$datadirectory"
chmod 755 -R "$datadirectory"
chmod 755 -R /data/config
chown -R "$PUID:$PGID" "$datadirectory"
chown -R "$PUID:$PGID" "/data/config"
echo "...done"
echo " "
