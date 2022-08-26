#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

#################
# Create folder #
#################

mkdir -p /config/addons_config/scrutiny/config
mkdir -p /config/addons_config/scrutiny/influxdb

cp /opt/scrutiny/config/* /config/addons_config/scrutiny/config/
cp /opt/scrutiny/influxdb/* /config/addons_config/scrutiny/influxdb/
rm -r /opt/scrutiny/config
rm -r /opt/scrutiny/influxdb
ln -s /config/addons_config/scrutiny/config /opt/scrutiny
ln -s /config/addons_config/scrutiny/influxdb /opt/scrutiny

################
# CRON OPTIONS #
################

# Align update with options
FREQUENCY=$(bashio::config 'Updates')
bashio::log.info "$FREQUENCY updates"

case $FREQUENCY in
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
