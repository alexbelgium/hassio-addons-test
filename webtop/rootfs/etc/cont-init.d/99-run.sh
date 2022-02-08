#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# Uprade
echo "Updating distribution"
apt-get update &>/dev/null || apk update &>/dev/null || true
apt-get -y upgrade &>/dev/null || apk upgrade --available &>/dev/null || true

# Fix mate software center
if [ -f /usr/lib/dbus-1.0/dbus-daemon-launch-helper ]; then
  echo "Allow software center"
  chmod u+s /usr/lib/dbus-1.0/dbus-daemon-launch-helper
  service dbus restart
fi

# Install specific apps
if bashio::config.has_value 'additional_apps'; then
  bashio::log.info "Installing additional apps :"
  # Install apps
  for APP in $(echo "$(bashio::config 'additional_apps')" | tr "," " "); do
    bashio::log.green "... $APP"
    # Test install with both apt-get and snap
    apt-get install -yqq $APP &>/dev/null || apk add --no-cache $APP &>/dev/null &&
      bashio::log.green "... done" ||
      bashio::log.red "... not successful, please check package name"
  done
fi
