#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

if [ -d "$HOME"/BirdSongs/StreamData ]; then
    bashio::log.fatal "Container stopping, saving temporary files"

    # Stop the services in parallel
    systemctl stop birdnet_analysis &
    systemctl stop birdnet_recording

    # Check if there are files in StreamData and move them to /data/StreamData
    mkdir -p /data/StreamData
    if [ "$(ls -A "$HOME"/BirdSongs/StreamData)" ]; then
        mv -v "$HOME"/BirdSongs/StreamData/* /data/StreamData/
    fi

    bashio::log.fatal "... files safe, allowing container to stop"
fi
