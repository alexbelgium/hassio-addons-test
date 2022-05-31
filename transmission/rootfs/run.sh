#!/usr/bin/bashio

####################
# Export variables #
####################

echo "Exporting variables"
for k in $(bashio::jq "/data/options.json" 'keys | .[]'); do
    sed -i "5a export $k=$(bashio::config $k)" /etc/openvpn/start.sh
    sed -i "5a echo export $k=$(bashio::config $k)" /etc/openvpn/start.sh
done
