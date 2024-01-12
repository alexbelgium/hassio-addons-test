#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

QBT_CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"

#################
# SET VARIABLES #
#################

# Ensure single vpn
if bashio::config.true 'openvpn_enabled' && bashio::config.true 'wireguard_enabled'; then
    bashio::log.warning "Both openvpn_enabled and wireguard_enabled are set. Openvpn configuration will be used"
    bashio::addon.option 'wireguard_enabled' false
fi

# Set variables
if bashio::config.true 'openvpn_enabled'; then
    vpn="openvpn"
    vpn_ending=".ovpn"
    vpn_interface="tun0"
else
    vpn="wireguard"
    vpn_ending=".conf"
    vpn_interface="wg0"
fi

# Permissions
chmod 755 /config/openvpn/*
chmod 755 /config/wireguard/*

#################
# CONFIGURE VPN #
#################

if bashio::config.true 'wireguard_enabled' || bashio::config.true 'openvpn_enabled'; then

    ############
    # MESSAGES #
    ############

    bashio::log.info "----------------------------"
    bashio::log.info "${vpn} enabled, configuring"
    bashio::log.info "----------------------------"

    # Get current ip
    curl -s ipecho.net/plain >/currentip

    ####################
    # CONFIG SELECTION #
    ####################

    # If openvpn_config option used
    if bashio::config.has_value "openvpn_config"; then
        openvpn_config=$(bashio::config 'openvpn_config')
        # If file found
        if [ -f /config/"${vpn}"/"${openvpn_config}" ]; then
            # If correct type
            if [[ "${openvpn_config}" == *"${vpn_ending}" ]]; then
                echo "... configured config file : using /addon_configs/$HOSTNAME/${vpn}/${openvpn_config}"
            else
                bashio::exit.nok "Configured ${vpn_ending} file : ${openvpn_config} is set but does not end by ${vpn_ending} ; it can't be used!"
            fi
        else
            bashio::exit.nok "Configured ${vpn_ending} file : ${openvpn_config} not found! Are you sure you added it in /addon_configs/$HOSTNAME/${vpn} using the Filebrowser addon ?"
        fi
        # If openvpn_config not set, but folder is not empty
    elif ls /config/"${vpn}"/*"${vpn_ending}" >/dev/null 2>&1; then
        # Look for openvpn files
        # Wildcard search for openvpn config files and store results in array
        mapfile -t VPN_CONFIGS < <(find /config/"${vpn}" -maxdepth 1 -name "*${vpn_ending}" -print)
        # Choose random config
        VPN_CONFIG="${VPN_CONFIGS[$RANDOM % ${#VPN_CONFIGS[@]}]}"
        # Get the VPN_CONFIG name without the path and extension
        openvpn_config="${VPN_CONFIG##*/}"
        echo "... ${vpn} enabled, but openvpn_config option empty. Selecting a random ${vpn_ending} file : ${openvpn_config}. Other available files :"
        printf '%s\n' "${VPN_CONFIGS[@]}"
        # If openvpn_enabled set, config not set, and openvpn folder empty
    else
        bashio::exit.nok "_enabled is set, however, your ${vpn} folder is empty ! Are you sure you added it in /addon_configs/$HOSTNAME/ using the Filebrowser addon ?"
    fi

    # Send to script
    sed -i "s|/config/${vpn}/config${vpn_ending}|/config/${vpn}/${openvpn_config}|g" /etc/s6-overlay/s6-rc.d/svc-qbittorrent/run

    #####################
    # OPENVPN SPECIFICS #
    #####################

    if [[ "$vpn" == "openvpn" ]]; then

        # Check openvpn config file
        ###########################

        # Double check exists
        if [ ! -f "/config/${vpn}/${openvpn_config}" ]; then
            bashio::warning "$file not found"
            return 1
        else
            # Get variable
            file="/config/${vpn}/${openvpn_config}"

            # Check each lines
            cp "$file" /tmpfile
            line_number=0
            while read -r line; do
                # Increment the line number
                ((line_number++))

                # Check if lines starting with auth-user-pass have a valid argument
                ###################################################################
                if [[ "$line" == "auth-user-pass"* ]]; then
                    # Extract the second argument
                    file_name="$(echo "$line" | awk -F' ' '{print $2}')"
                    # If second argument is null or -
                    if [ -z "$file_name" ] || [[ "$file_name" == -* ]]; then
                        # Insert to explain why a comment is made
                        sed -i "${line_number}i # The following line is commented out as does not contain a valid argument" "$file"
                        # Increment as new line added
                        ((line_number++))
                        # Comment out the line
                        sed -i "${line_number}s/^/# /" "$file"
                        # Go to next line
                        continue
                    fi
                fi

                # Check if the line contains a txt file
                #######################################
                if [[ ! $line =~ ^"#" ]] && [[ ! $line =~ ^";" ]] && [[ "$line" =~ \.txt ]] || [[ "$line" =~ \.crt ]] || [[ "$line" == "auth-user-pass"* ]]; then
                    # Extract the txt file name from the line
                    file_name="$(echo "$line" | awk -F' ' '{print $2}')"
                    # Check if the txt file exists
                    if [[ "$file_name" != *"/etc/openvpn/credentials"* ]] && [ ! -f "$file_name" ]; then
                        # Check if the txt file exists in the /config/openvpn/ directory
                        if [ -f "/config/openvpn/${file_name##*/}" ]; then
                            # Append /config/openvpn/ in front of the original txt file in the ovpn file
                            sed -i "${line_number}s|$file_name|/config/openvpn/${file_name##*/}|" "$file"
                            # Print a success message
                            bashio::log.warning "Appended /config/openvpn/ to ${file_name##*/} in $file"
                        else
                            # Print an error message
                            bashio::log.warning "$file_name is referenced in your ovpn file but does not exist, and can't be found either in the /config/openvpn/ directory"
                        fi
                    fi
                fi
            done </tmpfile
            rm /tmpfile

            # Standardize lf
            dos2unix "$file"

            # Remove custom up & down
            sed -i '/^up /s/^/#/' "$file"
            sed -i '/^down /s/^/#/' "$file"

            # Remove blank lines
            sed -i '/^[[:blank:]]*$/d' "$file"

            # Ensure config ends with a line feed
            sed -i "\$q" "$file"

            # Correct paths
            sed -i "s=/etc/openvpn=/config/openvpn=g" "$file"
            sed -i "s=/config/openvpn/credentials=/etc/openvpn/credentials=g" "$file"
        fi

        # Set credentials
        if bashio::config.has_value "openvpn_username"; then
            openvpn_username=$(bashio::config 'openvpn_username')
            echo "${openvpn_username}" >/etc/openvpn/credentials
        else
            bashio::exit.nok "Openvpn is enabled, but openvpn_username option is empty! Exiting"
        fi
        if bashio::config.has_value "openvpn_password"; then
            openvpn_password=$(bashio::config 'openvpn_password')
            echo "${openvpn_password}" >>/etc/openvpn/credentials
        else
            bashio::exit.nok "Openvpn is enabled, but openvpn_password option is empty! Exiting"
        fi

        # Add credentials file
        if grep -q ^auth-user-pass /config/openvpn/"${openvpn_config}"; then
            # Credentials specified are they custom ?
            file_name="$(sed -n "/^auth-user-pass/p" /config/openvpn/"${openvpn_config}" | awk -F' ' '{print $2}')"
            file_name="${file_name:-null}"
            if [[ "$file_name" != *"/etc/openvpn/credentials"* ]] && [[ "$file_name" != "null" ]]; then
                if [ -f "$file_name" ]; then
                    # If credential specified, exists, and is not the addon default
                    bashio::log.warning "auth-user-pass specified in the ovpn file, addon username and passwords won't be used !"
                else
                    # Credential referenced but doesn't exist
                    bashio::log.warning "auth-user-pass $file_name is referenced in your ovpn file but does not exist, and can't be found either in the /config/openvpn/ directory. The addon will attempt to use it's own username and password instead."
                    # Comment previous lines
                    sed -i '/^auth-user-pass/i # specified auth-user-pass file not found, disabling' /config/openvpn/"${openvpn_config}"
                    sed -i '/^auth-user-pass/s/^/#/' /config/openvpn/"${openvpn_config}"
                    # No credentials specified, using addons username and password
                    echo "# Please do not remove the line below, it allows using the addon username and password" >>/config/openvpn/"${openvpn_config}"
                    echo "auth-user-pass /etc/openvpn/credentials" >>/etc/openvpn/"${openvpn_config}"
                fi
            else
                # Standardize just to be sure
                sed -i "/\/etc\/openvpn\/credentials/c auth-user-pass \/etc\/openvpn\/credentials" /config/openvpn/"${openvpn_config}"
            fi
        else
            # No credentials specified, using addons username and password
            echo "# Please do not remove the line below, it allows using the addon username and password" >>/config/openvpn/"${openvpn_config}"
            echo "auth-user-pass /etc/openvpn/credentials" >>/config/openvpn/"${openvpn_config}"
        fi

        # Permissions
        chmod 755 /etc/openvpn/*
        chmod 600 /etc/openvpn/credentials
        chmod 755 /etc/openvpn/*.sh
        chmod +x /etc/openvpn/*.sh

        # WITH CONTAINER BINDING
        #########################
        # If alternative mode enabled, bind container
        if bashio::config.true 'openvpn_alt_mode'; then
            echo "Using container binding"

            # Remove interface
            echo "... deleting previous interface settings"
            sed -i '/Interface/d' "$QBT_CONFIG_FILE"

            # Modify ovpn config
            if grep -q route-nopull /config/openvpn/"${openvpn_config}"; then
                echo "... removing route-nopull from your config.ovpn"
                sed -i '/route-nopull/d' /config/openvpn/"${openvpn_config}"
            fi

            # Exit
            exit 0
        else
            # Modify ovpn config
            if ! grep -q route-nopull /config/openvpn/"${openvpn_config}"; then
                echo "... adding route-nopull to your config.ovpn"
                sed -i "1a route-nopull" /config/openvpn/"${openvpn_config}"
            fi
        fi
    fi

    #######################
    # WIREGUARD SPECIFICS #
    #######################

    if [[ "$vpn" == "wireguard" ]]; then
        echo "wireguard"

        # Set interface name
        vpn_interface="${openvpn_config%.*}"

        # Set gateway
        DEFAULT_IPV4_GATEWAY=$(ip -4 route list 0/0 | cut -d ' ' -f 3 | head -n 1)

        # Default
        ip rule add fwmark 8080 table webui
        ip route add default via "$DEFAULT_IPV4_GATEWAY" table webui

        # Look for local networks first
        ip rule add fwmark 8080 table main suppress_prefixlength 1

        # Ensure ingress is allowed in allowed_ips
        allowed_ips="$(sed -n "/AllowedIPs/p" /config/openvpn/"${openvpn_config}")"
        # Use comma as separator and read into an array
        IFS=',' read -ra ADDR <<< "$list"
        # Initialize an empty array to hold the filtered elements
        filtered=()
        # Loop over the elements
        for i in "${ADDR[@]}"; do
            # If the element does not contain "::", add it to the filtered array
            if [[ $i != *::* ]]; then
                filtered+=("$i")
            fi
        done
        # Add additional elements
        for i in 10.0.0.0/8 192.168.0.0/16 172.16.0.0/12 172.30.0.0/16; do
            filtered+=("$i")
        done
        # Join the filtered elements with commas and store in a variable
        allowed_ips=$(IFS=', '; echo "${filtered[*]}")
        # Store it in the conf file
        sed -i "|^AllowedIPs|c AllowedIPs=$allowed_ips" /config/openvpn/"${openvpn_config}"

    fi

    ###################
    # Accept local ip #
    ###################

    ip route add 10.0.0.0/8 via 172.30.32.1
    ip route add 192.168.0.0/16 via 172.30.32.1
    ip route add 172.16.0.0/12 via 172.30.32.1
    ip route add 172.30.0.0/16 via 172.30.32.1

    ##################
    # CONFIGURE QBIT #
    ##################

    echo "... $vpn correctly set, qbittorrent will run tunnelled"

    # Connection with interface binding
    echo "Using interface binding in the qBittorrent app"

    # Define preferences line
    cd /config/qBittorrent/ || exit 1

    # If qBittorrent.conf exists
    if [ -f "$QBT_CONFIG_FILE" ]; then
        # Remove previous line and bind tun0
        echo "... deleting previous interface settings"
        sed -i '/Interface/d' "$QBT_CONFIG_FILE"

        # Bind tun0
        echo "... binding ${vpn_interface} interface in qBittorrent configuration"
        sed -i "/\[Preferences\]/ i\Connection\\\Interface=${vpn_interface}" "$QBT_CONFIG_FILE"
        sed -i "/\[Preferences\]/ i\Connection\\\InterfaceName=${vpn_interface}" "$QBT_CONFIG_FILE"

        # Add to ongoing session
        sed -i "/\[BitTorrent\]/a \Session\\\Interface=${vpn_interface}" "$QBT_CONFIG_FILE"
        sed -i "/\[BitTorrent\]/a \Session\\\InterfaceName=${vpn_interface}" "$QBT_CONFIG_FILE"

    else
        bashio::log.error "qBittorrent config file doesn't exist, openvpn must be added manually to qbittorrent options "
        exit 1
    fi

else

    ##################
    # REMOVE OPENVPN #
    ##################

    # Ensure no redirection by removing the direction tag
    if [ -f "$QBT_CONFIG_FILE" ]; then
        sed -i '/Interface/d' "$QBT_CONFIG_FILE"
    fi
    bashio::log.info "Direct connection without VPN enabled"

fi
