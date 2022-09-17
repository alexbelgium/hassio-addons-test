#!/usr/bin/env bashio
# shellcheck shell=bash

export SITE_TITLE=$(bashio::config 'SITE_TITLE')
export SERVER_DOMAIN=$(bashio::config 'SERVER_DOMAIN')
export BASE_URL=$(bashio::config 'BASE_URL')

echo "site title $SITE_TITLE"
echo "server domain $SERVER_DOMAIN"
echo "base url $BASE_URL"

#sed "s/^APP.*/APP      = $SITE_TITLE/" /data/gitea/conf/app.ini
#sed "s/^DOMAIN.*/DOMAIN      = $SERVER_DOMAIN/" /data/gitea/conf/app.ini
#sed "s/^ROOT_URL.*/ROOT_URL       = $BASE_URL/" /data/gitea/conf/app.ini

bashio::config.require.ssl
#sed "/PROTOCOL/d " /data/gitea/conf/app.ini
#sed "/CERT_FILE/d " /data/gitea/conf/app.ini
#sed "/KEY_FILE/d " /data/gitea/conf/app.ini
if bashio::config.true 'ssl'; then
export CERT_FILE=$(bashio::config 'certfile')
export KEY_FILE=$(bashio::config 'keyfile')
export PROTOCOL=https
	#sed "/server/a PROTOCOL  = https" /data/gitea/conf/app.ini
	#sed "/server/a ROOT_URL  = https://$BASE_URL:3000/" /data/gitea/conf/app.ini
	#sed "/server/a CERT_FILE = $(bashio::config 'certfile')" /data/gitea/conf/app.ini
	#sed "/server/a KEY_FILE = $(bashio::config 'keyfile')" /data/gitea/conf/app.ini
#else
	#sed "/server/a PROTOCOL  = http" /data/gitea/conf/app.ini
	#sed "/server/a ROOT_URL  = http://$BASE_URL:3000/" /data/gitea/conf/app.ini
fi

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./usr/bin/entrypoint
