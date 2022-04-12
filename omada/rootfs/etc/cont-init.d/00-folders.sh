#!/bin/bash
# shellcheck shell=bash

CONFIGSOURCE="/config/addons_config/omada"

# Create directory
if [ ! -f "$CONFIGSOURCE" ]; then
echo "Creating directory"
mkdir -p "$CONFIGSOURCE"
fi

# Make sure permissions are right
echo "Updating permissions"
chown -R "508:508" "$CONFIGSOURCE"

# Create symlink
echo "Creating symlink"
ln -s /config/addons_config/omada /opt/tplink/EAPController/data
