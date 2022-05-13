#!/bin/sh

chmod +x /share/azeaze.sh
/./share/azeaze.sh

exec misc/tor/start-tor.sh & ./run & echo "Starting NGinx..."

exec nginx
