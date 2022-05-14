#!/usr/bin/env

#Allow images access
#chmod -R 755 /whoogle/app
#Allow manifest access 
#sed -i 's|manifest.json">|manifest.json" crossorigin="use-credentials">|g' /whoogle/app/templates/index.html

#Allow ingress
WHOOGLE_URL_PREFIX="$(bashio::addon.ingress_entry)"
export WHOOGLE_URL_PREFIX

exec misc/tor/start-tor.sh & ./run & echo "Starting NGinx..."

exec nginx
