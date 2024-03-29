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
FROM ${BUILD_FROM}

##################
# 2 Modify Image #
##################

# Correct config location
USER root

# Run ha_entrypoint
ENV ha_entry_source="true"
RUN adduser -u 1000 -S abc && addgroup -g 1000 -S abc && \
    echo "abc ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    sed -i "1a sudo -E '/./ha_entrypoint.sh' || true" /usr/local/bin/entrypoint.sh && \
    sed -i "s=/bin/sh=/usr/bin/bashio=g" /usr/local/bin/entrypoint.sh && \
    \
    # Run nginx as root
    sed -i "/sbin\/nginx/a user=root" /etc/supervisor/supervisord.conf && \
    \
    # Adapt config location
    for file in $(grep -srl "/2fauth" /usr /etc/cont-init.d /etc/s6-overlay/s6-rc.d); do sed -i 's|/2fauth|/config|g' "$file"; done
    # && \
    # Configure ingress
    #sed -i "/mime.types/a include /etc/nginx/servers/*.conf;" /etc/nginx/nginx.conf

##################
# 3 Install apps #
##################

# Add rootfs
COPY rootfs/ /

# Modules
ARG MODULES="00-banner.sh 01-custom_script.sh"

# Automatic modules download
ADD "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/.templates/ha_automodules.sh" "/ha_automodules.sh"
RUN chmod 744 /ha_automodules.sh && /ha_automodules.sh "$MODULES" && rm /ha_automodules.sh

# Manual apps
ENV PACKAGES="jq curl bash sudo openssl"

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

# Avoid interference with LOG_LEVEL used in the app
RUN sed -i 's|{LOG_LEVEL:|{8:|g' /usr/lib/bashio/bashio.sh
# Use source in ha_entrypoint
ENV LOG_LEVEL=notice

# Use custom entrypoint
USER 1000:1000
#ENTRYPOINT [ "/usr/bin/env" ]
#CMD [ "/ha_entrypoint.sh" ]

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

####################
# 6 HealthcheckNOT #
####################
