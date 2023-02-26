#!/usr/bin/env bashio
# shellcheck shell=bash

##################
# Starting redis #
##################
exec redis-server & bashio::log.info "Starting redis"

####################
# Starting mongodb #
####################
exec mongod & bashio::log.info "Starting mongod"

################
# Starting app #
################
cd /srv || true
npm start /./docker-entrypoint.sh & bashio::log.info "Starting binance bot"

#########################
# Starting Trading View #
#########################
bashio::log.info "Starting trading view"
cd /app || true
python main.py || python3 main.py
