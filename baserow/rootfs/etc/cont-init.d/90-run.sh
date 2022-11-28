#!/usr/bin/env bashio

###################
# CORRECT FOLDERS #
###################

if [ -d /baserow/data ]; then
  cp -rnf /baserow/data/* /data/
  rm -r /baserow/data
fi
ln -s /data /baserow/data

if [ -d /etc/postgresql/11/main ]; then
  cp -rnf /etc/postgresql/11/main/* /data/postgresql/
  rm -r /etc/postgresql/11/main
fi
ln -s /data/postgresql /etc/postgresql/11/main

#############
# START APP #
#############

start /./baserow.sh
