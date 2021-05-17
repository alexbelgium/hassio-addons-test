#!/usr/bin/with-contenv bashio

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
