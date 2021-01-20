ARG BUILD_VERSION

FROM bitwardenrs/server:1.18.0

# Add bashio
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
    curl jq \
    && apt-get clean \
    && curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.7.1.tar.gz" \
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

COPY run.sh /
RUN chmod 777 /run.sh
ENTRYPOINT [ "/run.sh" ]

VOLUME [ "/ssl", "/data" ]
