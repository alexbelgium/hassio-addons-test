#################
# 1 Build Image #
#################

ARG BUILD_FROM
ARG BUILD_UPSTREAM="2.1.27"
FROM anthonyraymond/joal:$BUILD_UPSTREAM

##################
# 2 Modify Image #
##################

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_VERSION
ARG BUILD_UPSTREAM="2.1.27"

RUN \
    #Install Joal
    wget -O /tmp/joal.tar.gz "https://github.com/anthonyraymond/joal/releases/download/$BUILD_UPSTREAM/joal.tar.gz" \
    && mkdir -p /data/joal \
    && tar zxvf /tmp/joal.tar.gz -C /data/joal \
    && rm /data/joal/jack-of* \
    #Clean
    && rm -fr \
    /tmp/* \
    /var/{cache,log}/* \
    /var/lib/apt/lists/*

##################
# 3 Install apps #
##################

# Add rootfs
COPY rootfs/ /

# Manual apps
ENV PACKAGES="jq \
    nginx"

# Automatic apps & bashio
RUN $(ls /bin/bash &>/dev/null) || (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) && \
    $(curl --help &>/dev/null) || (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) && \
    curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/automatic_packages.sh" --output /automatic_packages.sh && \
    chmod 777 /automatic_packages.sh && \
    /automatic_packages.sh "${PACKAGES:-}" && \
    rm /automatic_packages.sh || printf '%s\n' "${PACKAGES:-}" > /ENVFILE

################
# 4 Entrypoint #
################

RUN chmod 777 /entrypoint.sh
ENTRYPOINT [ "/usr/bin/env" ]
CMD [ "/entrypoint.sh" ] 

############
# 5 Labels #
############

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="alexbelgium (https://github.com/alexbelgium)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="alexbelgium (https://github.com/alexbelgium)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/alexbelgium" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
