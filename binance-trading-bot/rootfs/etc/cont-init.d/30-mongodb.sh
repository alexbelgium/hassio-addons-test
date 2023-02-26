#!/usr/bin/env bashio
# shellcheck shell=bash

echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories
echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories

apk add mongodb mongodb-tools --no-cache >/dev/null
mkdir -p /data/db/
