#!/usr/bin/with-contenv bashio

#################
# NGINX SETTING #
#################
declare port
declare certfile
declare ingress_interface
declare ingress_port
declare keyfile

echo "Adapting for ingress"
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf

# Allow uppercase url
echo "Allowing case sensitive url"
[ -f "/app/emby/dashboard-ui/modules/emby-apiclient/connectionmanager.js" ] && echo "file exists"
grep -rl toLowerCase /app/emby/dashboard-ui/modules/emby-apiclient | xargs sed -i 's/toLowerCase()/toString()/g'
