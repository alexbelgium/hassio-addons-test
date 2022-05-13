#!/bin/sh

exec misc/tor/start-tor.sh & ./run & bashio::net.wait_for 5000 localhost 900

bashio::log.info "Starting NGinx..."

exec nginx
