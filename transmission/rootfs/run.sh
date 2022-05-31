#!/usr/bin/bashio

####################
# Export variables #
####################

echo "Exporting variables"
for k in $(bashio::jq "${__BASHIO_ADDON_CONFIG}" 'keys | .[]'); do
    sed -i "1a export $k=$(bashio::config $k)" /etc/openvpn/start.sh
done
