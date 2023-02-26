#!/usr/bin/env bashio
# shellcheck shell=bash

echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories
echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories

apk add mongodb mongodb-tools --no-cache
mkdir -p /data/db/
