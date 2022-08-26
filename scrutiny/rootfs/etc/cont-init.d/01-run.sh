#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

#################
# Create folder #
#################

echo "Updating folders structure"
DATABASELOCATION="/data"
mkdir -p "$DATABASELOCATION"/config
mkdir -p "$DATABASELOCATION"/influxdb
if [ -f /opt/scrutiny/config ]; then rm -r /opt/scrutiny/config; fi
if [ -f /opt/scrutiny/influxdb ]; then rm -r /opt/scrutiny/influxdb; fi
ln -s "$DATABASELOCATION"/config /opt/scrutiny
ln -s "$DATABASELOCATION"/influxdb /opt/scrutiny

###############################
# Migrating previous database #
###############################

if [ -f /data/scrutiny.db ]; then
bashio::log.warning "Previous database detected, migration will start"
mv /data/scrutiny.db "$DATABASELOCATION"/config/
fi

######
# TZ #
######

# Align timezone with options
TZ="$(bashio::config 'TZ')"
bashio::log.info "Timezone : $TZ"

if bashio::config.has_value "TZ"; then
sed -i "1a export TZ=$TZ" /etc/cont-init.d/10-timezone
fi

################
# CRON OPTIONS #
################

# Align update with options
FREQUENCY="$(bashio::config 'Updates')"
bashio::log.info "$FREQUENCY updates"

case "$FREQUENCY" in
    "Hourly")
        sed -i "1a export COLLECTOR_CRON_SCHEDULE=\"0 * * * *\"" /etc/cont-init.d/50-cron-config
        ;;

    "Daily")
        sed -i "1a export COLLECTOR_CRON_SCHEDULE=\"0 0 * * *\"" /etc/cont-init.d/50-cron-config
        ;;

    "Weekly")
        sed -i "1a export COLLECTOR_CRON_SCHEDULE=\"0 0 * * 0\"" /etc/cont-init.d/50-cron-config
        ;;
esac
