#!/usr/bin/env bashio
# ==============================================================================
# Home Assistant Community Add-on: Bitwarden
# This file configures nginx
# ==============================================================================
declare certfile
declare keyfile
declare max_body_size

bashio::config.require.ssl

if bashio::config.true 'ssl'; then
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
    sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
    sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf
else
    mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
fi

max_body_size="10M"
# Increase body size to match config
if bashio::config.has_value 'request_size_limit'; then
    max_body_size=$(bashio::config 'request_size_limit')
fi
sed -i "s/%%max_body_size%%/${max_body_size}/g" \
    /etc/nginx/includes/server_params.conf
    
# ==============================================================================
# Home Assistant Community Add-on: Bitwarden
# Runs the Nginx daemon
# ==============================================================================
bashio::net.wait_for 80
bashio::log.info "Starting NGinx..."

exec nginx

#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bitwarden
# Runs the Bitwarden RS server
# ==============================================================================
declare admin_token
declare log_level
declare request_size_limit
declare secret_key

# Set defaults
export DATA_FOLDER=/data
export ROCKET_PORT=80
export ROCKET_WORKERS=2

# Set a random secret, to remove confusing warning from logs.
secret_key=$(openssl rand -base64 32)
export ROCKET_SECRET_KEY="${secret_key}"

# Find the matching log level
if bashio::config.has_value 'log_level'; then
    case "$(bashio::string.lower "$(bashio::config 'log_level')")" in
        all|trace)
            log_level="trace"
            ;;
        debug)
            log_level="debug"
            ;;
        info|notice)
            log_level="info"
            ;;
        warning)
            log_level="warn"
            ;;
        error|fatal)
            log_level="error"
            ;;
        off)
            log_level="off"
            ;;
    esac

    export LOG_LEVEL="${log_level}"
fi

# Show admin token in the log, if config does not exist.
if ! bashio::fs.file_exists '/data/config.json'; then
    admin_token=$(openssl rand -base64 48)
    export ADMIN_TOKEN="${admin_token}"

    bashio::log.info
    bashio::log.info
    bashio::log.info "READ THIS CAREFULLY! READ THIS CAREFULLY!"
    bashio::log.info
    bashio::log.info
    bashio::log.info "This is your temporary random admin token/password!"
    bashio::log.info
    bashio::log.info "${admin_token}"
    bashio::log.info
    bashio::log.info "Be sure to change it in the admin panel, as soon as possible."
    bashio::log.info
    bashio::log.info "After you have changed ANY setting in the admin panel,"
    bashio::log.info "the add-on will NOT generate a new token on each start"
    bashio::log.info "and stops showing this message."
    bashio::log.info
fi

# API request size limit
if bashio::config.has_value 'request_size_limit'; then
    request_size_limit=$(bashio::config 'request_size_limit')
    export ROCKET_LIMITS="{json=${request_size_limit}}"
fi

# Always enable Websockets
export WEBSOCKET_ENABLED=true
export WEBSOCKET_PORT=8080

# Run the Bitwarden server
bashio::log.info 'Starting the Bitwarden RS server...'
cd /opt || bashio::exit.nok
exec ./bitwarden_rs
