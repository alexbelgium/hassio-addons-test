#!/usr/bin/with-contenv bashio

bashio::log.info "Setting variables"
# MOFIFY DATA PATH
sed -i "s|'Downloads\SavePath=/downloads/'|"Downloads\SavePath=$(bashio::config 'downloads')"|g" /defaults/qBittorrent.conf
sed -i "s|'Downloads\TempPath=/downloads/incomplete/'|Downloads\TempPath=$(bashio::config 'temppath')|g" /defaults/qBittorrent.conf
echo 'WebUI\HostHeaderValidation=false' >> /defaults/qBittorrent.conf

bashio::log.info "Default username/password : admin/adminadmin"
