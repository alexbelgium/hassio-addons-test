#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -euo pipefail

bashio::log.info "Update structure"

# New persistent location (writable for non-root)
PERSIST_ROOT="/data/netalertx"

# Legacy location used by older add-on versions
LEGACY_ROOT="/config"

# Marker so migration is attempted only once (unless it couldn't run)
MIGRATION_MARKER="${PERSIST_ROOT}/.migrated_from_legacy_config"

mkdir -p "${PERSIST_ROOT}/config" "${PERSIST_ROOT}/db"

migrate_legacy_once() {
  # If we've already migrated, do nothing
  if [ -f "${MIGRATION_MARKER}" ]; then
    return 0
  fi

  local migrated_any="false"

  for folder in config db; do
    local src="${LEGACY_ROOT}/${folder}"
    local dst="${PERSIST_ROOT}/${folder}"

    # Only migrate if destination is empty-ish (avoid overwriting user changes)
    if [ -d "${src}" ] && [ -z "$(ls -A "${dst}" 2>/dev/null || true)" ]; then
      # Try reading legacy dir; if not readable, skip with warning
      if ls -A "${src}" >/dev/null 2>&1; then
        if [ -n "$(ls -A "${src}" 2>/dev/null || true)" ]; then
          bashio::log.info "Migrating legacy ${src} -> ${dst} (copy, no overwrite)"
          if cp -rn "${src}/." "${dst}/" 2>/dev/null; then
            migrated_any="true"
          else
            bashio::log.warning "Legacy data found in ${src} but could not be copied (permissions)."
          fi
        fi
      else
        bashio::log.warning "Legacy folder ${src} exists but is not readable by this container user."
      fi
    fi
  done

  # Create marker only if migration succeeded OR there was nothing to migrate.
  # If permissions blocked it, we leave marker absent so a restart can retry.
  if [ "${migrated_any}" = "true" ] || { [ ! -d "${LEGACY_ROOT}/config" ] && [ ! -d "${LEGACY_ROOT}/db" ]; }; then
    date -Is > "${MIGRATION_MARKER}" || true
  fi
}

seed_from_app_and_link() {
  echo "Creating symlinks"
  for folder in config db; do
    echo "Creating for ${folder}"
    mkdir -p "${PERSIST_ROOT}/${folder}"

    # If upstream image ships defaults in /app/<folder>, copy once into persistence
    if [ -d "/app/${folder}" ] && [ ! -L "/app/${folder}" ] && [ -n "$(ls -A "/app/${folder}" 2>/dev/null || true)" ]; then
      cp -rn "/app/${folder}/." "${PERSIST_ROOT}/${folder}/" || true
    fi

    rm -rf "/app/${folder}" || true
    ln -sfn "${PERSIST_ROOT}/${folder}" "/app/${folder}"
  done

  # Make sure DB is writable by current user if present
  if [ -f "${PERSIST_ROOT}/db/app.db" ]; then
    chmod u+rw "${PERSIST_ROOT}/db/app.db" || true
  fi
}

#####################
# Do migrate + link  #
#####################
migrate_legacy_once
seed_from_app_and_link

#####################
# Configure network  #
#####################

config_file="${PERSIST_ROOT}/config/app.conf"

execute_main_logic() {
  bashio::log.info "Initiating scan of Home Assistant network configuration..."

  local local_ip
  local_ip="$(bashio::network.ipv4_address)"
  local_ip="${local_ip%/*}"
  echo "... Detected local IP: ${local_ip}"
  echo "... Scanning network for changes"

  if ! command -v arp-scan >/dev/null 2>&1; then
    bashio::log.error "arp-scan command not found. Please install arp-scan to proceed."
    exit 1
  fi

  if ! grep -q "^SCAN_SUBNETS" "${config_file}"; then
    bashio::log.fatal "SCAN_SUBNETS is not found in ${config_file}, please correct your file first"
  fi

  for interface in $(bashio::network.interfaces); do
    echo "Scanning interface: ${interface}"

    if grep -q "${interface}" "${config_file}"; then
      echo "... ${interface} is already configured in app.conf"
      continue
    fi

    SCAN_SUBNETS="$(grep "^SCAN_SUBNETS" "${config_file}" | head -1)"
    if [[ "${SCAN_SUBNETS}" != *"${local_ip}"*"${interface}"* ]]; then
      NEW_SCAN_SUBNETS="${SCAN_SUBNETS%]}, '${local_ip}/24 --interface=${interface}']"
      sed -i "/^SCAN_SUBNETS/c\\${NEW_SCAN_SUBNETS}" "${config_file}"

      VALUE="$(arp-scan --interface="${interface}" "${local_ip}/24" 2>/dev/null \
        | grep "responded" \
        | awk -F'.' '{print $NF}' \
        | awk '{print $1}' || true)"

      echo "... ${interface} is available in Home Assistant (with ${VALUE} devices), added to app.conf"
    fi
  done

  bashio::log.info "Network scan completed."
}

# Don’t block cont-init forever; wait up to 60s for app.conf
if [ ! -f "${config_file}" ]; then
  bashio::log.warning "${config_file} not found yet; waiting briefly..."
  for _ in 1 2 3 4 5 6 7 8 9 10 11 12; do
    [ -f "${config_file}" ] && break
    sleep 5
  done
fi

if [ -f "${config_file}" ]; then
  execute_main_logic
else
  bashio::log.warning "Still no ${config_file}; skipping network auto-config for this start."
fi
