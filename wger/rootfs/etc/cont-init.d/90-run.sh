#!/usr/bin/env bashio

############################
# Change database location #
############################
touch /data/database.sqlite
sed -i "s|/home/wger/db/database.sqlite|/data/database.sqlite|g" /home/wger/src/settings.py


#####################
# Align permissions #
#####################
(set -o posix; export -p) > /data/env.sh
chown -R 1000:1000 /data
chmod -R 777 /data

############################
# Merge static directories #
############################
#cp -rnf /home/wger/src/wger/core/static/* /data/static || true
#cp -rnf /home/wger/src/static/* /data/static || true
#cp -rnf /home/wger/src/wger/software/static/* /data/static || true

nginx & echo "Starting nginx"
