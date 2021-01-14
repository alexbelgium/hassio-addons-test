#!/bin/sh

/opt/adguardhome/AdGuardHome -h 127.0.0.1 -c /etc/adguard/AdGuardHome.yaml -w /opt/adguardhome/work --no-check-update --port 45160 --work-dir /data/adguard
