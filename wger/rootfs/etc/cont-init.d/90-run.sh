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

#############
# Start app #
#############
(set -o posix; export -p) > /env.sh
chmod 777 /env.sh
/bin/su -s /bin/bash -c '/./env.sh; cd /home/wger/src && /home/wger/entrypoint.sh' wger
