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

FROM alpine:3.22.2 AS ha_tools
RUN apk add --no-cache \
      ca-certificates \
      curl \
      jq \
      sudo \
      gosu \
      pax-utils

# Collect binaries + their runtime deps into /out (so we can COPY them into the hardened image)
RUN set -eux; \
    mkdir -p /out/usr/bin /out/usr/lib /out/lib /out/etc/ssl/certs /out/etc; \
    cp -a /usr/bin/jq /usr/bin/curl /usr/bin/sudo /usr/bin/gosu /out/usr/bin/; \
    cp -a /etc/ssl/certs/ca-certificates.crt /out/etc/ssl/certs/; \
    cp -a /etc/sudoers /out/etc/; \
    if [ -d /etc/sudoers.d ]; then cp -a /etc/sudoers.d /out/etc/; fi; \
    if [ -d /usr/lib/sudo ]; then cp -a /usr/lib/sudo /out/usr/lib/; fi; \
    for bin in /usr/bin/jq /usr/bin/curl /usr/bin/sudo /usr/bin/gosu; do \
      scanelf --needed --nobanner --format '%n' "$bin" \
        | tr ',' '\n' \
        | while read -r lib; do \
            [ -z "$lib" ] && continue; \
            p="$(find /lib /usr/lib -name "$lib" -type f -o -type l | head -n1 || true)"; \
            [ -z "$p" ] && continue; \
            mkdir -p "/out$(dirname "$p")"; \
            cp -a "$p" "/out$(dirname "$p")/"; \
            rp="$(readlink -f "$p" || true)"; \
            if [ -n "$rp" ] && [ "$rp" != "$p" ]; then \
              mkdir -p "/out$(dirname "$rp")"; \
              cp -a "$rp" "/out$(dirname "$rp")/"; \
            fi; \
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

# Bring in tools (NO apk in final stage)
COPY --from=ha_tools /out/ /

# (optional) make sure cert bundle is found by everything
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

##################
# 4 Prepare apk #
##################

# Copy apk infrastructure from builder
COPY --from=builder /sbin/apk /sbin/apk
COPY --from=builder /lib/apk /lib/apk
COPY --from=builder /etc/apk /etc/apk
COPY --from=builder /usr/share/apk /usr/share/apk
COPY --from=builder /usr/lib/libcrypto.so.* /usr/lib/
COPY --from=builder /usr/lib/libssl.so.* /usr/lib/
COPY --from=builder /usr/lib/libz.so.* /usr/lib/

# Ensure /sbin is in PATH
ENV PATH="/sbin:${PATH}"

##################
# 5 Install sudo #
##################
COPY --from=builder /usr/bin/sudo /usr/bin/sudo

RUN apk add jq curl yamllint ca-certificates

# Modules
ARG MODULES="00-banner.sh"

# Automatic modules download
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_automodules.sh" "/ha_automodules.sh"
RUN chmod 744 /ha_automodules.sh && /ha_automodules.sh "$MODULES" && rm /ha_automodules.sh

# Manual apps
ENV PACKAGES="jq"

# Automatic apps & bashio
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_autoapps.sh" "/ha_autoapps.sh"
RUN chmod 744 /ha_autoapps.sh && /ha_autoapps.sh "$PACKAGES" && rm /ha_autoapps.sh

################
# 4 Entrypoint #
################

# Add entrypoint
ENV S6_STAGE2_HOOK=/ha_entrypoint.sh
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_entrypoint.sh" "/ha_entrypoint.sh"

# Entrypoint modifications
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_entrypoint_modif.sh" "/ha_entrypoint_modif.sh"
RUN chmod 777 /ha_entrypoint.sh /ha_entrypoint_modif.sh && /ha_entrypoint_modif.sh && rm /ha_entrypoint_modif.sh

# Standalone bashio command
#ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/bashio-standalone.sh" "/.bashio-standalone.sh"
#RUN chmod 777 /.bashio-standalone.sh

#WORKDIR /
ENTRYPOINT [ "/usr/bin/env" ]
CMD [ "/ha_entrypoint.sh" ]
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

####################
# 6 HealthcheckNOT #
####################
# # In the dockerfile Changing hard links if possible
# RUN for folder in config db; do \
#     echo "Adapting hard links" && \
#     grep -rl "/app/$folder" / 2>/dev/null | xargs sed -i "s|/app/$folder|/config/$folder|g"; \
# done
