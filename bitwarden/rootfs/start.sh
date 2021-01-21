#!/bin/bash

# Start Nginx
./etc/cont-init.d/nginx.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

# Start bitwarden
./etc/services.d/bitwarden/finish -D
status=$?

# Start nginx
./etc/services.d/nginx/finish -D
status=$?

# Start bitwarden
./etc/services.d/bitwarden/run -D
status=$?

# Start nginx
./etc/services.d/nginx/run -D
status=$?
