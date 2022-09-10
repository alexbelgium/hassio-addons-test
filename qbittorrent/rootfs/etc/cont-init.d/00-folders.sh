#!/bin/bash

mkdir -p /config/addons_config/qBittorrent

if [ -d /config/qBittorrent ]; then
    cp /config/qBittorrent/* /config/addons_config/qBittorrent/*
    echo "Files were moved to /config/addons_config/qBittorrent" > /config/qBittorrent/filesmoved
fi
