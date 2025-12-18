#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -eu

bashio::log.info "Update structure"

# Persist everything under add-on data (writable)
PERSIST_ROOT="/data/netalertx"

echo "Creating symlinks"
mkdir -p "${PERSIST_ROOT}/config" "${PERSIST_ROOT}/db"

for folder in config db; do
    echo "Creating for ${folder}"

    # If upstream shipped default files, copy them once into persistent storage
    if [ -d "/app/${folder}" ] && [ ! -L "/app/${folder}" ] && [ "$(ls -A "/app/${folder}" 2>/dev/null || true)" ]; then
        cp -rn "/app/${folder}/." "${PERSIST_ROOT}/${folder}/" || true
    fi

    # Replace /app/<folder> with symlink to persistent dir
    rm -rf "/app/${folder}" || true
    ln -sfn "${PERSIST_ROOT}/${folder}" "/app/${folder}"
done

# If the DB already exists, ensure it's writable by the current user
if [ -f "${PERSIST_ROOT}/db/app.db" ]; then
    chmod u+rw "${PERSIST_ROOT}/db/app.db" || true
fi

#####################
# Configure network #
#####################

config_file="${PERSIST_ROOT}/config/app.conf"

execute_main_logic() {
    bashio::log.info "Initiating scan of Home Assistant network configuration..."

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

    # Iterate over network interfaces
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

if [ -f "${config_file}" ]; then
    execute_main_logic
else
    bashio::log.warning "${config_file} not found yet; skipping network auto-config for this start."
fi
