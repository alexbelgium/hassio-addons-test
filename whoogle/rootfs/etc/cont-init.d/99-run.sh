#!/bin/sh

sed -i "s|(self.value)|'aze'(self.value)|g" /whoogle/app/models/endpoint.py
sed -i "s|(self.value)|'aze'{self.value}|g" /whoogle/app/models/endpoint.py

exec misc/tor/start-tor.sh & ./run & echo "Starting NGinx..."

exec nginx
