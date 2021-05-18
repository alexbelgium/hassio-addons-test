#!/usr/bin/with-contenv bashio

##########
# BANNER #
##########

if bashio::supervisor.ping; then
    bashio::log.blue \
        '-----------------------------------------------------------'
    bashio::log.blue " Add-on: $(bashio::addon.name)"
    bashio::log.blue " $(bashio::addon.description)"
    bashio::log.blue \
        '-----------------------------------------------------------'

    bashio::log.blue " Add-on version: $(bashio::addon.version)"
    if bashio::var.true "$(bashio::addon.update_available)"; then
        bashio::log.magenta ' There is an update available for this add-on!'
        bashio::log.magenta \
            " Latest add-on version: $(bashio::addon.version_latest)"
        bashio::log.magenta ' Please consider upgrading as soon as possible.'
    else
        bashio::log.green ' You are running the latest version of this add-on.'
    fi

    bashio::log.blue " System: $(bashio::info.operating_system)" \
        " ($(bashio::info.arch) / $(bashio::info.machine))"
    bashio::log.blue " Home Assistant Core: $(bashio::info.homeassistant)"
    bashio::log.blue " Home Assistant Supervisor: $(bashio::info.supervisor)"

    bashio::log.blue \
        '-----------------------------------------------------------'
    bashio::log.blue \
        ' Please, share the above information when looking for help'
    bashio::log.blue \
        ' or support in, e.g., GitHub, forums or the Discord chat.'
    bashio::log.blue \
        '-----------------------------------------------------------'
fi

##########
# LAUNCH #
##########

cd /binance-trade-bot
APIKEY=$(bashio::config 'APIKEY')
sed -i 's/APIKEY/$APIKEY/g' user.cfg
APISECRET=$(bashio::config 'APISECRET')
sed -i 's/APISECRET/$APISECRET/g' user.cfg
CURRENTCOIN=$(bashio::config 'CURRENTCOIN')
sed -i 's/CURRENTCOIN/$CURRENTCOIN/g' user.cfg
BRIDGE=$(bashio::config 'BRIDGE')
sed -i 's/BRIDGE/$BRIDGE/g' user.cfg
DOMAIN=$(bashio::config 'DOMAIN')
sed -i 's/DOMAIN/$DOMAIN/g' user.cfg
HISTORY=$(bashio::config 'HISTORY')
sed -i 's/HISTORY/$HISTORY/g' user.cfg
SCOUTMULTI=$(bashio::config 'SCOUTMULTI')
sed -i 's/SCOUTMULTI/$SCOUTMULTI/g' user.cfg
SCOUTSLEEP=$(bashio::config 'SCOUTSLEEP')
sed -i 's/SCOUTSLEEP/$SCOUTSLEEP/g' user.cfg
STRATEGY=$(bashio::config 'STRATEGY')
sed -i 's/STRATEGY/$STRATEGY/g' user.cfg
BUYTIMEOUT=$(bashio::config 'BUYTIMEOUT')
sed -i 's/BUYTIMEOUT/$BUYTIMEOUT/g' user.cfg
SELLTIMEOUT=$(bashio::config 'SELLTIMEOUT')
sed -i 's/SELLTIMEOUT/$SELLTIMEOUT/g' user.cfg

python -m binance_trade_bot
