FROM jonaswinkler/paperless-ng:1.0.0

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install bashio
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    jq \
    && curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.10.1.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
    /tmp/bashio.tar.gz \
    --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -fr \
    /tmp/* \
    /var/{cache,log}/* \
    /var/lib/apt/lists/*

COPY rootfs/ /
RUN chmod +x /etc/init.d/run.sh
    
VOLUME ["/share", "/ssl", "/data"]
