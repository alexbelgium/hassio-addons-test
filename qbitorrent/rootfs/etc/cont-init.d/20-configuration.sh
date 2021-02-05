#!/usr/bin/with-contenv bashio

# MOFIFY DATA PATH
sed -i "s|'/downloads/'|"$(bashio::config 'downloads')"|g" /defaults/qBittorrent.conf
sed -i "s|'/downloads/incomplete/'|$(bashio::config 'temppath')|g" /defaults/qBittorrent.conf