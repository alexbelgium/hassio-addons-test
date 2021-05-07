#!/usr/bin/with-contenv bashio



python -m binance_trade_bot



APIKEY=$(bashio::config 'apikey')
APISECRET=$(bashio::config 'apisecret')
BASE=$(bashio::config 'basecurrency')
QUOTE=$(bashio::config 'quotecurrency')
GRANULARITY=$(bashio::config 'granularity')
LIVE="1"
VERBOSE="1"

touch /config.json
echo '{' >> /config.json
echo '    "binance" : {' >> /config.json
echo '        "api_url" : "https://api.binance.com",' >> /config.json
echo "        \"api_key\" : \"$APIKEY\"," >> /config.json
echo "        \"api_secret\" : \"$APISECRET\"," >> /config.json
echo '        "config" : {' >> /config.json
echo "            \"base_currency\" : \"$BASE\"," >> /config.json
echo "            \"quote_currency\" : \"$QUOTE\"," >> /config.json
echo "            \"granularity\" : \"$GRANULARITY\"," >> /config.json
echo "            \"live\" : \"$LIVE\"," >> /config.json
echo "            \"verbose\" : \"$VERBOSE\"" >> /config.json
echo '        }' >> /config.json
echo '    }' >> /config.json
echo '}' >> /config.json

python3 pycryptobot.py --market BTC-GBP --granularity 3600 --live 1 --verbose 0 --selllowerpcnt -2

