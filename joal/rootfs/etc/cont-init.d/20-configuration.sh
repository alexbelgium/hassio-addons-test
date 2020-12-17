#!/usr/bin/with-contenv bashio
# ==============================================================================

declare CONFIG
declare minupload
declare maxupload
declare simultaneousseed
declare client
declare keeptorrent

# Create dirs
if ! bashio::fs.directory_exists '/share/joal-conf'; then
  mkdir '/share/joal-conf'
fi

if ! bashio::fs.directory_exists '/share/joal-conf/clients'; then
  mkdir '/share/joal-conf/clients'
fi

if ! bashio::fs.directory_exists '/share/joal-conf/torrents'; then
  mkdir '/share/joal-conf/torrents'
fi

if ! bashio::fs.file_exists '/share/joal-conf/config.json'; then
  echo "{}" > /share/joal-conf/config.json
fi

# Populate options
CONFIG=$(</share/joal-conf/config.json)

minupload=$(bashio::config 'minUploadRate')
maxupload=$(bashio::config 'maxUploadRate')
simultaneousseed=$(bashio::config 'simultaneousSeed')
client=$(bashio::config 'client')
keeptorrent=$(bashio::config 'keepTorrentWithZeroLeechers')

# Defaults
CONFIG=$(bashio::jq "${CONFIG}" ".\"minUploadRate\"="${minupload}"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"maxUploadRate\"="${maxupload}"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"simultaneousSeed\"="${simultaneousseed}"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"client\"="${client}"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"keepTorrentWithZeroLeechers\"="${keeptorrent}"")

echo "${CONFIG}" > /share/joal-conf/config.json
