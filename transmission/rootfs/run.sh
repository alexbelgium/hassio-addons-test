#!/usr/bin/bashio

####################
# Export variables #
####################

echo "Exporting variables"
for k in $(bashio::jq "/data/options.json" 'keys | .[]'); do
    echo "export $k=$(bashio::config $k)"
    sed -i "1a export $k=$(bashio::config $k)" /etc/openvpn/start.sh
done
