#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

####################
# Update structure #
####################

# 1) Fix Permissions
# No sudo needed if running as root in entrypoint
for folder in /tmp /tmp/run/tmp /tmp/api /tmp/log /tmp/run /tmp/nginx/active-config "$NETALERTX_DATA" "$NETALERTX_DB" "$NETALERTX_CONFIG"; do
    # Only try to create/chmod if the variable is not empty
    if [ -n "$folder" ]; then
        mkdir -p "$folder"
        chown -R 20211:20211 "$folder"
        chmod -R 755 "$folder"
    fi
done

# 2) Create Symlinks correctly
# This ensures /data/db points to /config/db, etc.
for item in db config; do
    # Remove existing file/folder if it exists to prevent 'File exists' errors
    rm -rf "/data/$item"
    # Create the link: ln -s [TARGET] [LINK_NAME]
    ln -sf "/config/$item" "/data/$item"
    chown -R 20211:20211 "/data/$item"
    chmod -R 755 "/data/$item"
done

# Ensure log files exist and are owned by the app user
for logfile in "/tmp/log/app.php_errors.log" "/tmp/log/cron.log" "/tmp/log/stdout.log" "/tmp/log/stderr.log"; do
    touch "$logfile"
    chown 20211:20211 "$logfile"
done

# Ensure /tmp is fully writable (needed for mktemp)
chmod 1777 /tmp

#####################
# Configure network #
#####################

# Configuration file path
config_file="/config/config/app.conf"

if [ -f /config/db/app.db ]; then
    chmod a+rwx /config/db/app.db
fi

# Function to execute the main logic
execute_main_logic() {
    bashio::log.info "Initiating scan of Home Assistant network configuration..."

    # Get the local IPv4 address
    local_ip="$(bashio::network.ipv4_address)"
    local_ip="${local_ip%/*}" # Remove CIDR notation
    echo "... Detected local IP: $local_ip"
    echo "... Scanning network for changes"

    # Ensure arp-scan is installed
    if ! command -v arp-scan &> /dev/null; then
        bashio::log.error "arp-scan command not found. Please install arp-scan to proceed."
        exit 1
    fi

    # Get current settings
    if ! grep -q "^SCAN_SUBNETS" "$config_file"; then
        bashio::log.fatal "SCAN_SUBNETS is not found in your $config_file, please correct your file first"
    fi

    # Iterate over network interfaces
    for interface in $(bashio::network.interfaces); do
        echo "Scanning interface: $interface"

        # Check if the interface is already configured
        if grep -q "$interface" "$config_file"; then
            echo "... $interface is already configured in app.conf"
        else
            # Update SCAN_SUBNETS in app.conf
            SCAN_SUBNETS="$(grep "^SCAN_SUBNETS" "$config_file" | head -1)"
            if [[ "$SCAN_SUBNETS" != *"$local_ip"*"$interface"* ]]; then
                # Add to the app.conf
                NEW_SCAN_SUBNETS="${SCAN_SUBNETS%]}, '${local_ip}/24 --interface=${interface}']"
                sed -i "/^SCAN_SUBNETS/c\\$NEW_SCAN_SUBNETS" "$config_file"
                # Check availability of hosts
                VALUE="$(arp-scan --interface="$interface" "${local_ip}/24" 2> /dev/null \
                    | grep "responded" \
                    | awk -F'.' '{print $NF}' \
                    | awk '{print $1}' || true)"
                echo "... $interface is available in Home Assistant (with $VALUE devices), added to app.conf"
            fi
        fi
    done

    bashio::log.info "Network scan completed."

}

# Function to wait for the config file
wait_for_config_file() {
    echo "Waiting for $config_file to become available..."
    while [ ! -f "$config_file" ]; do
        sleep 5 # Wait for 5 seconds before checking again
    done
    echo "$config_file is now available. Starting the script."
    execute_main_logic
}

# Main script logic
if [ -f "$config_file" ]; then
    execute_main_logic
else
    wait_for_config_file &
    true
fi
