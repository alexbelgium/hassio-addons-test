#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

#################
# Set PUID PGID #
#################

# Get from options
PGID=$(bashio::config 'PGID')
PUID=$(bashio::config 'PUID')
# If blank, set 0
PGID="${PGID:-0}"
PUID="${PUID:-0}"
# Write in permission file
sed -i "1a PGID=$PGID" /etc/cont-init.d/01-setup-perms
sed -i "1a PUID=$PUID" /etc/cont-init.d/01-setup-perms
# Information
bashio::log.info "Setting PUID=$PUID, PGID=$PGID" 

#####################
# Set Configuration #
#####################

# Config location
CONFIGLOCATION="$(bashio::config 'CONFIG_LOCATION')"

# Rename base folder
mv /app /tdarr
sed -i "s|/app|/tdarr|g" /etc/cont-init.d/*
sed -i "s|/app|/tdarr|g" /etc/services.d/*

# Symlink configs
rm -r /tdarr/configs
ln -snf "$CONFIGLOCATION" /tdarr/configs

# Text
bashio::log.info "Setting config location to $CONFIGLOCATION"
