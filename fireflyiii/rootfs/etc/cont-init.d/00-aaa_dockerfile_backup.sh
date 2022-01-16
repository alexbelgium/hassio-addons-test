#!/bin/bash
# If dockerfile failed install manually
if [ -e "/MODULESFILE" ]; then
    echo "Executing modules script"
    PACKAGES=$(</MODULESFILE)
    (
        ##############################
        # Automatic modules download #
        ##############################
        if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash); fi &&
            if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl); fi &&
            mkdir -p /tmpscripts /etc/cont-init.d &&
            for scripts in $MODULES; do curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/$scripts" -o /tmpscripts/"$scripts"; done &&
            if [ -d /etc/cont-init.d ]; then /bin/cp -rf /tmpscripts/* /etc/cont-init.d/ && chmod -R 755 /etc/cont-init.d; fi &&
            rm -rf /tmpscripts || printf '%s\n' "${MODULES:-}" >/MODULESFILE
    ) >/dev/null

fi

if [ -e "/ENVFILE" ]; then
    echo "Executing script"
    PACKAGES=$(</ENVFILE)

    #######################
    # Automatic installer #
    #######################
    if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) >/dev/null; fi &&
        if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) >/dev/null; fi &&
        curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/automatic_packages.sh" --output /automatic_packages.sh &&
        chmod 777 /automatic_packages.sh &&
        eval /./automatic_packages.sh "$PACKAGES" &&
        rm /automatic_packages.sh
fi
