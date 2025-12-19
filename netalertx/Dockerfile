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

############################
# 0) Tools stage (apk OK)  #
############################
# We build a tiny payload in /out containing:
# - jq + its shared libs (libjq, libonig, etc.)
# - gosu + its shared libs
# IMPORTANT: we do NOT bring sudo to avoid breaking NetAlertX hardened behavior.
FROM alpine:3.22 AS ha_tools

RUN apk add --no-cache \
    jq \
    gosu \
    pax-utils

RUN set -eux; \
    mkdir -p /out; \
    for bin in /usr/bin/jq /usr/bin/gosu; do \
      mkdir -p "/out$(dirname "$bin")"; \
      cp -a "$bin" "/out$bin"; \
      # Copy runtime deps. Skip musl loader to avoid clobbering base image libc/loader.
      lddtree -l "$bin" | while read -r dep; do \
        case "$dep" in \
          /lib/ld-musl-*.so.1) \
            continue ;; \
          /*) \
            mkdir -p "/out$(dirname "$dep")"; \
            cp -a "$dep" "/out$(dirname "$dep")/"; \
            ;; \
        esac; \
      done; \
    done

##################
# 1) Final image #
##################
ARG BUILD_FROM
FROM ghcr.io/jokob-sk/netalertx:latest

# S6 settings (keep yours)
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

USER 0

# Add rootfs
COPY rootfs/ /

# Bring in jq + gosu (and their libs). NO apk in final stage.
COPY --from=ha_tools /out/ /

# (optional) make sure cert bundle is found by everything
# NetAlertX base normally already provides certs; this just standardizes lookup.
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

###########
# Modules #
###########
ARG MODULES="00-banner.sh"

# Automatic modules download
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_automodules.sh" "/ha_automodules.sh"
RUN chmod 744 /ha_automodules.sh \
    && /ha_automodules.sh "$MODULES" \
    && rm /ha_automodules.sh

#################
# Manual apps   #
#################
ENV PACKAGES=""

# Automatic apps & bashio
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_autoapps.sh" "/ha_autoapps.sh"
RUN chmod 744 /ha_autoapps.sh \
    && /ha_autoapps.sh "$PACKAGES" \
    && rm /ha_autoapps.sh

################
# 4 Entrypoint #
################
ENV S6_STAGE2_HOOK=/ha_entrypoint.sh
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_entrypoint.sh" "/ha_entrypoint.sh"

# Entrypoint modifications
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_entrypoint_modif.sh" "/ha_entrypoint_modif.sh"
RUN chmod 777 /ha_entrypoint.sh /ha_entrypoint_modif.sh \
    && /ha_entrypoint_modif.sh \
    && rm /ha_entrypoint_modif.sh

#WORKDIR /
ENTRYPOINT [ "/usr/bin/env" ]
CMD [ "/ha_entrypoint.sh" ]

# Your preferred shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
ENV BUILD_VERSION="${BUILD_VERSION}"
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
