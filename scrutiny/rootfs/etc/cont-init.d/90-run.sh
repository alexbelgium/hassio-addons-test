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

rm /config/crontabs/* || true
sed -i '$d' /etc/crontabs/root
sed -i -e '$a @reboot /run.sh' /etc/crontabs/root

# Align update with options
FREQUENCY=$(bashio::config 'Updates')
bashio::log.info "$FREQUENCY updates"

case $FREQUENCY in
    "Hourly")
        sed -i -e '$a 0 * * * * /run.sh' /etc/crontabs/root
        ;;

    "Daily")
        sed -i -e '$a 0 0 * * * /run.sh' /etc/crontabs/root
        ;;

    "Weekly")
        sed -i -e '$a 0 0 * * 0 /run.sh' /etc/crontabs/root
        ;;
esac
