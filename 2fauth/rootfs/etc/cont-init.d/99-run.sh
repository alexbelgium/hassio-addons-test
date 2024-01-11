#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# shellcheck disable=SC2086
set -e

#################
# NGINX SETTING #
#################

declare ingress_interface
declare ingress_port

FB_BASEURL=$(bashio::addon.ingress_entry)
export FB_BASEURL

declare ADDON_PROTOCOL=http
# Generate Ingress configuration
if bashio::config.true 'ssl'; then
    ADDON_PROTOCOL=https
fi

#port=$(bashio::addon.port 80)
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s|%%protocol%%|${ADDON_PROTOCOL}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%port%%|${ingress_port}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%interface%%|${ingress_interface}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%subpath%%|${FB_BASEURL}/|g" /etc/nginx/servers/ingress.conf
mkdir -p /var/log/nginx && touch /var/log/nginx/error.log

sed -i "/#RewriteBase/c RewriteBase /2fauth/" /var/www/2fauth/public/.htaccess

###############
# Set APP_KEY #
###############

# Check if APP_KEY is still default, if yes then generate a new one
if [[ "$(bashio::config "APP_KEY")" == *"SomeRandomStringOf32CharsExactl1"* ]]; then
    bashio::log.warning "APP_KEY is still default, a new one will be generated with a backup stored in /config"
    # Generate 32 characters
    APP_KEY="$(openssl rand -base64 32)"
    # Adapt addon options
    bashio::addon.option APP_KEY "$APP_KEY"
    # Backup APP_KEY
    echo "Create backup file"
    file=/config/APP_KEY_"$(date +"%Y-%m-%d")"
    if [ -f "$file" ]; then
        counter=1
        file2="$file_$counter"
        while [ -f "$file2" ]; do
            ((counter++))
            file2="$file_$counter"
        done
    fi
    echo "$APP_KEY" > "$file"
    # Restart addon to make sure new value is considered
    bashio::addon.restart
fi

#####################
# Align permissions #
#####################

(set -o posix; export -p) > /srv/.env
echo "Setting permissions"
chown -R 1000:1000 /config
chmod -R 777 /config

bashio::log.info "Starting app"
