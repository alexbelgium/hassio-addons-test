#!/bin/bash
# If dockerfile failed install manually
if [ -e "/ENVFILE" ]; then
    echo "Executing script"
    PACKAGES=$(</ENVFILE)
    (
        #######################
        # Automatic installer #
        #######################
        $(ls /bin/bash &>/dev/null) || (apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash || apt install -yqq --no-install-recommends bash) &&
            $(curl --help &>/dev/null) || (apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl || apt install -yqq --no-install-recommends curl) &&
            curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/automatic_packages.sh" --output /automatic_packages.sh &&
            chmod 777 /automatic_packages.sh &&
            eval /./automatic_packages.sh "$PACKAGES" &&
            rm /automatic_packages.sh
    ) >/dev/null

fi
