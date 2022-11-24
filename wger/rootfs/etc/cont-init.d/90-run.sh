#!/usr/bin/env bashio

LOCATION=/data
mkdir -p "$LOCATION"
echo "Defining database"
touch "$LOCATION"/database.sqlite
ln -s "$LOCATION"/database.sqlite /home/wger/db

echo "Updating database"
python3 manage.py migrate || true

echo "Defining permissions"
chown -R wger:wger "$LOCATION"
chown -R wger:wger "/home/wger"
chmod -R 777 "$LOCATION"

echo "Launch app"
pip install -e . &>/dev/null
sed -i "1a cd /home/wger/src" /home/wger/entrypoint.sh

echo "Setting static"
rmdir /home/wger/static && ln -s /home/wger/src/wger/core/static /home/wger || true

#su -l wger -c "\
#  cd /home/wger/src && \
#  export FROM_EMAIL='wger Workout Manager <wger@example.com>' && \
#  export DEBIAN_FRONTEND=noninteractive && \
#  export FROM_EMAIL='wger Workout Manager <wger@example.com>' && \
#  export LANG=en_US.UTF-8 && \
#  export LANGUAGE=en_US:en && \
#  export LC_ALL=en_US.UTF-8 && \
#  export PATH=/home/wger/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && \
#  export PYTHONDONTWRITEBYTECODE=1 && \
#  export PYTHONUNBUFFERED=1 && \
#  export DJANGO_DB_DATABASE=/data/database.sqlite && \
#  /bin/bash /home/wger/entrypoint.sh \
#  "
  
/bin/su -s /bin/bash -c 'cd /home/wger/src && /home/wger/entrypoint.sh' wger

#/./home/wger/entrypoint.sh
