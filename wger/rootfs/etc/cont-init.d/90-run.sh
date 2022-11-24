#!/usr/bin/env bashio

############################
# Change database location #
############################
export DJANGO_DB_DATABASE="/data/database.sqlite"
touch /data/database.sqlite

#####################
# Align permissions #
#####################
chown -R 1000:1000 /data
chmod -R 777 /data
sed -i "s|wger:x:0:0|wger:x:1000:1000|g" /etc/passwd

#############
# Start app #
#############
/./home/wger/entrypoint.sh
