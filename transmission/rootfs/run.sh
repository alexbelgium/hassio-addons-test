#!/usr/bin/bashio

####################
# Export variables #
####################

echo "Exporting variables"
for k in $(bashio::jq "/data/options.json" 'keys | .[]'); do
    export $k=$(bashio::config $k)
done

/./etc/openvpn/start.sh
