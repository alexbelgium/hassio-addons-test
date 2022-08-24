#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

##################
# URL CORRECTION #
##################

# allow true url for ingress
#grep -rl '/web/' /opt/scrutiny/web/ | xargs sed -i 's|/web/|./|g'
grep -rl '/api/' /opt/scrutiny/web/ | xargs sed -i 's|/api/|api/|g'
grep -rl 'api/' /opt/scrutiny/web/ | xargs sed -i 's|api/|./api/|g'

################
# CRON OPTIONS #
################

#rm /config/crontabs/* || true
#sed -i '$d' /etc/crontabs/root
#sed -i -e '$a @reboot /run.sh' /etc/crontabs/root

# Align update with options
#FREQUENCY=$(bashio::config 'Updates')
#bashio::log.info "$FREQUENCY updates"

#case $FREQUENCY in
#    "Hourly")
#        sed -i -e '$a 0 * * * * /run.sh' /etc/crontabs/root
#        ;;
#
#    "Daily")
#        sed -i -e '$a 0 0 * * * /run.sh' /etc/crontabs/root
#        ;;
#
#    "Weekly")
#        sed -i -e '$a 0 0 * * 0 /run.sh' /etc/crontabs/root
#        ;;
#esac
