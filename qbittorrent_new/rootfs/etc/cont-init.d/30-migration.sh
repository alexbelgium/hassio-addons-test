#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# Create new folders
mkdir -p /config/wireguard
mkdir -p /config/openvpn


if [ -f /config/addons_config/qBittorrent/qBittorrent.conf ]; then
    bashio::log.warning "----------------------------------------"
    bashio::log.warning "Migrating configuration to the new addon"
    bashio::log.warning "----------------------------------------"
    mv /config/addons_config/qBittorrent/* /config/
    rm -r /config/addons_config/qBittorrent
    bashio::log.yellow "... moved files from /config/addons_config/qBittorrent to /addon_configs/$HOSTNAME (must be accessed with my Filebrowser addon)"
fi

if bashio::config.has_value 'openvpn_enable'; then
    if bashio::config.true 'openvpn_enabled'; then
        bashio::addon.option "VPN_ENABLED" "true"
        bashio::log.yellow "... openvpn_enable : was true, VPN_ENABLED set to true"
        bashio::addon.option "VPN_TYPE" "openvpn"
        bashio::log.yellow "... openvpn_enable : was true, VPN_TYPE set to openvpn"
    fi
    bashio::addon.option "openvpn_enable"
    bashio::log.yellow "... openvpn_enable : removed as not used anymore"
fi

if bashio::config.has_value 'openvpn_username'; then
    bashio::addon.option "VPN_USERNAME" "$(bashio::config "openvpn_username")"
    bashio::log.yellow "... openvpn_username : was set, VPN_USERNAME set to $(bashio::config "openvpn_username")"
    bashio::addon.option "openvpn_username"
    bashio::log.yellow "... openvpn_username : removed as not used anymore"
fi

if bashio::config.has_value 'openvpn_password'; then
    bashio::addon.option "VPN_PASSWORD" "$(bashio::config "openvpn_password")"
    bashio::log.yellow "... openvpn_password : was set, VPN_PASSWORD set to $(bashio::config "openvpn_password")"
    bashio::addon.option "openvpn_password"
    bashio::log.yellow "... openvpn_password : removed as not used anymore"
fi

if bashio::config.has_value 'whitelist'; then
    bashio::addon.option "LAN_NETWORK" "$(bashio::config "whitelist")"
    bashio::log.yellow "... whitelist : was set, LAN_NETWORK set to $(bashio::config "whitelist")"
    bashio::addon.option "whitelist"
    bashio::log.yellow "... whitelist : removed as not used anymore"
fi

if bashio::config.has_value 'openvpn_config'; then
    openvpn_config="$(bashio::config "openvpn_config")"
    if [ -f "$openvpn_config" ]; then
        mv "$openvpn_config" /config/openvpn/
    fi
fi
