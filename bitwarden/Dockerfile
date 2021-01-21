ARG BUILD_VERSION

FROM bitwardenrs/server:1.18.0

# add Nginx
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
    libmariadb-dev-compat=1:10.3.27-0+deb10u1 \
    libpq5=11.9-0+deb10u1 \
    nginx=1.14.2-2+deb10u3 \
    && apt-get clean \
    && rm -f -r \
    /etc/nginx \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log

# Add bashio
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
    curl jq \
    && apt-get clean \
    && curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.10.1.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
    /tmp/bashio.tar.gz \
    --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -fr /tmp/bashio.tar.gz

# Copy root filesystem
COPY rootfs /

# Launch bitwarden
RUN chmod 777 /start.sh
CMD [ "/start.sh" ]

VOLUME [ "/ssl", "/data" ]
