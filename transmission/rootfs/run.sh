#!/usr/bin/bashio

####################
# Export variables #
####################

echo "Exporting variables"
for k in $(bashio::jq "/data/options.json" 'keys | .[]'); do
    sed -i "1a export $k=$(bashio::config $k)" /etc/openvpn/*.sh
    sed -i "1a echo export $k=$(bashio::config $k)" /etc/openvpn/*.sh
done
