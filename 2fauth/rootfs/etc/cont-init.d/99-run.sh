#!/bin/sh
# shellcheck shell=bash
set -e

sudo -u 1000:1000 -s /bin/sh -c "/usr/local/bin/entrypoint.sh"
