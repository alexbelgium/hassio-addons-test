#============================#
#  ALEXBELGIUM'S DOCKERFILE  #
#============================#
#           _.------.
#       _.-`    ('>.-`"""-.
# '.--'`       _'`   _ .--.)
#    -'         '-.-';`   `
#    ' -      _.'  ``'--.
#        '---`    .-'""`
#               /`
#=== Home Assistant Addon ===#

#################
# 1 Build Image #
#################

ARG BUILD_FROM
ARG BUILD_VERSION
ARG BUILD_UPSTREAM=4.0
FROM ${BUILD_FROM}

##################
# 2 Modify Image #
##################

# ADD scripts
RUN sed -i '1a /./run.sh' /etc/openvpn/start.sh \
    && sed -i '1a chmod +x /run.sh' /etc/openvpn/start.sh \
    && sed -i '/exec openvpn/i /./entrypoint.sh' /etc/openvpn/start.sh \
    && sed -i '/exec openvpn/i chmod +x /entrypoint.sh' /etc/openvpn/start.sh

#    sed -i "s|/bin/bash|/usr/bin/env bashio|g" /etc/openvpn/start.sh \
#    && sed -i '1a export OPENVPN_PROVIDER=$(bashio::config "OPENVPN_PROVIDER")' /etc/openvpn/start.sh \
#    && sed -i '1a export OPENVPN_CONFIG=$(bashio::config "OPENVPN_CONFIG")' /etc/openvpn/start.sh \
#    && sed -i '1a export OPENVPN_USERNAME=$(bashio::config "OPENVPN_USERNAME")' /etc/openvpn/start.sh \
#    && sed -i '1a export OPENVPN_PASSWORD=$(bashio::config "OPENVPN_PASSWORD")' /etc/openvpn/start.sh \
#    && sed -i '1a export LOCAL_NETWORK=$(bashio::config "LOCAL_NETWORK")' /etc/openvpn/start.sh \
    && sed -i '/exec openvpn/i ./entrypoint.sh' /etc/openvpn/start.sh \
    && sed -i '/exec openvpn/i chmod +x /entrypoint.sh' /etc/openvpn/start.sh

# MOFIFY DATA PATH
ENV DEBUG=false
ENV TRANSMISSION_HOME="/addons_config/transmission"
ENV TRANSMISSION_DOWNLOAD_DIR="/addons_config/transmission/downloads"
ENV TRANSMISSION_INCOMPLETE_DIR="/addons_config/transmission/incomplete"
ENV TRANSMISSION_WATCH_DIR="/addons_config/transmission/watch_dir"

##################
# 3 Install apps #
##################

# Add rootfs
COPY rootfs/ /

# Modules
ARG MODULES="00-banner.sh 90-dns_set.sh 92-local_mounts.sh 92-smb_mounts.sh "

# Automatic modules download
RUN if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) >/dev/null; fi \
    && if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) >/dev/null; fi \
    && mkdir -p /etc/cont-init.d \
    && for scripts in $MODULES; do echo "$scripts" && curl -f -L -s -S "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/$scripts" -o /etc/cont-init.d/"$scripts" && [ "$(sed -n '/\/bin/p;q' /etc/cont-init.d/"$scripts")" != "" ] || (echo "script failed to install $scripts" && exit 1); done \
    && chmod -R 755 /etc/cont-init.d || printf '%s\n' "${MODULES}" >/MODULESFILE

# Manual apps
ENV PACKAGES=""

# Automatic apps & bashio
RUN if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash) >/dev/null; fi \
    && if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl) >/dev/null; fi \
    && curl -f -L -s -S "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/automatic_packages.sh" --output /automatic_packages.sh \
    && chmod 777 /automatic_packages.sh \
    && eval /./automatic_packages.sh "${PACKAGES:-}" \
    && rm /automatic_packages.sh || printf '%s\n' "${PACKAGES:-}" > /ENVFILE

################
# 4 Entrypoint #
################

#RUN chmod 777 /entrypoint.sh
#WORKDIR /
#ENTRYPOINT [ "/usr/bin/env" ]
#CMD [ "/entrypoint.sh" ]
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
