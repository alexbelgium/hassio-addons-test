#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

WIREGUARD_STATE_DIR="/var/run/wireguard"
QBT_CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
declare wireguard_config=""
declare wireguard_runtime_config=""
declare configured_name

mkdir -p "${WIREGUARD_STATE_DIR}"

if ! bashio::config.true 'wireguard_enabled'; then
    rm -f "${WIREGUARD_STATE_DIR}/config" "${WIREGUARD_STATE_DIR}/interface"
    exit 0
fi

if bashio::config.true 'openvpn_enabled'; then
    bashio::exit.nok 'OpenVPN and WireGuard cannot be enabled simultaneously. Disable one of them.'
fi

if bashio::config.true 'openvpn_alt_mode'; then
    bashio::log.warning 'The openvpn_alt_mode option is ignored when WireGuard is enabled.'
fi

port="$(bashio::addon.port '51820/udp' || true)"
if bashio::var.has_value "${port}"; then
    bashio::log.info "WireGuard host port ${port}/udp mapped to container port 51820."
else
    bashio::log.info 'WireGuard port 51820/udp is not exposed in the add-on options. Continuing with outbound-only connectivity.'
fi

sanitize_wireguard_config_ipv4_only() {
    local input_file="$1"
    local output_file="$2"

    rm -f "${output_file}"

    while IFS= read -r line || [ -n "${line}" ]; do
        case "${line}" in
            Address*)
                IFS=',' read -ra parts <<< "${line#*=}"
                ipv4_parts=()
                for part in "${parts[@]}"; do
                    trimmed="$(echo "${part}" | xargs)"
                    [[ -z "${trimmed}" || "${trimmed}" == *:* ]] && continue
                    ipv4_parts+=("${trimmed}")
                done
                if [ "${#ipv4_parts[@]}" -gt 0 ]; then
                    printf 'Address = %s\n' "$(IFS=,; echo "${ipv4_parts[*]}")" >> "${output_file}"
                else
                    bashio::log.debug 'Dropped Address line containing only IPv6 entries while creating IPv4-only WireGuard config.'
                fi
                ;;
            AllowedIPs*)
                IFS=',' read -ra parts <<< "${line#*=}"
                ipv4_parts=()
                for part in "${parts[@]}"; do
                    trimmed="$(echo "${part}" | xargs)"
                    [[ -z "${trimmed}" || "${trimmed}" == *:* ]] && continue
                    ipv4_parts+=("${trimmed}")
                done
                if [ "${#ipv4_parts[@]}" -gt 0 ]; then
                    printf 'AllowedIPs = %s\n' "$(IFS=,; echo "${ipv4_parts[*]}")" >> "${output_file}"
                else
                    bashio::log.debug 'Dropped AllowedIPs line containing only IPv6 entries while creating IPv4-only WireGuard config.'
                fi
                ;;
            DNS*)
                IFS=',' read -ra parts <<< "${line#*=}"
                filtered_dns=()
                for part in "${parts[@]}"; do
                    trimmed="$(echo "${part}" | xargs)"
                    [[ -z "${trimmed}" ]] && continue
                    if [[ "${trimmed}" == *:* ]]; then
                        continue
                    fi
                    filtered_dns+=("${trimmed}")
                done
                if [ "${#filtered_dns[@]}" -gt 0 ]; then
                    printf 'DNS = %s\n' "$(IFS=,; echo "${filtered_dns[*]}")" >> "${output_file}"
                fi
                ;;
            *)
                printf '%s\n' "${line}" >> "${output_file}"
                ;;
        esac
    done < "${input_file}"
}

if bashio::config.has_value 'wireguard_config'; then
    configured_name="$(bashio::config 'wireguard_config')"
    configured_name="${configured_name##*/}"
    if [[ -z "${configured_name}" ]]; then
        bashio::log.info 'wireguard_config option left empty. Attempting automatic selection.'
    elif bashio::fs.file_exists "/config/wireguard/${configured_name}"; then
        wireguard_config="/config/wireguard/${configured_name}"
    else
        bashio::exit.nok "WireGuard configuration '/config/wireguard/${configured_name}' not found."
    fi
fi

if [ -z "${wireguard_config:-}" ]; then
    mapfile -t configs < <(find /config/wireguard -maxdepth 1 -type f -name '*.conf' -print)
    if [ "${#configs[@]}" -eq 0 ]; then
        bashio::exit.nok 'WireGuard is enabled but no .conf file was found in /config/wireguard.'
    elif [ "${#configs[@]}" -eq 1 ]; then
        wireguard_config="${configs[0]}"
        bashio::log.info "WireGuard configuration not specified. Using ${wireguard_config##*/}."
    elif bashio::fs.file_exists '/config/wireguard/config.conf'; then
        wireguard_config='/config/wireguard/config.conf'
        bashio::log.info 'Using default WireGuard configuration config.conf.'
    else
        bashio::exit.nok "Multiple WireGuard configuration files detected. Please set the 'wireguard_config' option."
    fi
fi

dos2unix "${wireguard_config}" >/dev/null 2>&1 || true

interface_name="$(basename "${wireguard_config}" .conf)"
if [[ -z "${interface_name}" ]]; then
    interface_name='wg0'
fi

wireguard_runtime_config="${wireguard_config}"

chmod 600 "${wireguard_runtime_config}" 2>/dev/null || true

has_ipv6_firewall_support() {
    ip6tables -t raw -L PREROUTING -n >/dev/null 2>&1 || return 1
    ip6tables -t nat -L PREROUTING -n >/dev/null 2>&1 || return 1
    ip6tables -m comment -h >/dev/null 2>&1 || return 1

    return 0
}

if ! has_ipv6_firewall_support; then
    wireguard_runtime_config="${WIREGUARD_STATE_DIR}/${interface_name}.ipv4.conf"
    bashio::log.warning 'IPv6 firewall support unavailable on the host. Creating IPv4-only WireGuard config to avoid ip6tables errors.'
    sanitize_wireguard_config_ipv4_only "${wireguard_config}" "${wireguard_runtime_config}"
    chmod 600 "${wireguard_runtime_config}" 2>/dev/null || true
fi

echo "${wireguard_runtime_config}" > "${WIREGUARD_STATE_DIR}/config"
echo "${interface_name}" > "${WIREGUARD_STATE_DIR}/interface"

if bashio::fs.file_exists "${QBT_CONFIG_FILE}"; then
    sed -i '/Interface/d' "${QBT_CONFIG_FILE}"
    sed -i "/\\[Preferences\\]/ i\\Connection\\\\Interface=${interface_name}" "${QBT_CONFIG_FILE}"
    sed -i "/\\[Preferences\\]/ i\\Connection\\\\InterfaceName=${interface_name}" "${QBT_CONFIG_FILE}"
    sed -i "/\\[BitTorrent\\]/a \\Session\\\\Interface=${interface_name}" "${QBT_CONFIG_FILE}"
    sed -i "/\\[BitTorrent\\]/a \\Session\\\\InterfaceName=${interface_name}" "${QBT_CONFIG_FILE}"
else
    bashio::log.warning "qBittorrent config file not found. Bind the client manually to interface ${interface_name}."
fi

bashio::log.info "WireGuard prepared with interface ${interface_name} using configuration ${wireguard_config##*/}."
