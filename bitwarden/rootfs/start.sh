#!/bin/bash

chmod 777 /etc/cont-init.d/nginx.sh
# Start Nginx
./etc/cont-init.d/nginx.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

# Start bitwarden
chmod 777 /etc/services.d/bitwarden/finish
./etc/services.d/bitwarden/finish -D
status=$?

# Start nginx
chmod 777 /etc/services.d/nginx/finish
./etc/services.d/nginx/finish -D
status=$?

# Start bitwarden
chmod 777 /etc/services.d/bitwarden/run
./etc/services.d/bitwarden/run -D
status=$?

# Start nginx
chmod 777 /etc/services.d/nginx/run
./etc/services.d/nginx/run -D
status=$?
