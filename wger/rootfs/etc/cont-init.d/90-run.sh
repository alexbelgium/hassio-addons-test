#!/usr/bin/env bashio

#####################
# Align permissions #
#####################
chown -R wger:wger /data
chmod -R 777 /data

############################
# Change database location #
############################
export DJANGO_DB_DATABASE="/data/database.sqlite"
touch /data/database.sqlite

#############
# Start app #
#############
/bin/su -s /bin/bash -c '/home/wger/entrypoint.sh' wger
