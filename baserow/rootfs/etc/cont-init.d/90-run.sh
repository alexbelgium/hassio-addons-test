#!/usr/bin/env bashio

###################
# CORRECT FOLDERS #
###################

if [ -d /etc/postgresql/11/main ]; then
  mkdir /data/postgresql
  cp -rnf /etc/postgresql/11/main/* /data/postgresql/
  rm -r /etc/postgresql/11/main
fi || true #debug mode
ln -s /data/postgresql /etc/postgresql/11/main || true #debug mode

if [ -d /baserow/data ]; then
  cp -rnf /baserow/data/* /data/
  rm -r /baserow/data
fi || true #debug mode
ln -s /data /baserow/data || true #debug mode

#############
# START APP #
#############

/./baserow.sh
