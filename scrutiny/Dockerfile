ARG BUILD_FROM
ARG BUILD_VERSION
ARG BUILD_UPSTREAM="27b923b5-ls11"
FROM ${BUILD_FROM}${BUILD_UPSTREAM}

# Copy root filesystem
COPY rootfs /

RUN \
    apk add --no-cache --virtual .build-dependencies \
        g++=10.2.1_pre1-r3 \
        gcc=10.2.1_pre1-r3 \
        libc-dev=0.7.2-r3 \
        linux-headers=5.7.8-r0 \
        make=4.3-r0 \
        py3-pip=20.3.4-r0 \
        python3-dev=3.8.7-r1 \
    \
    && apk add --no-cache \
        git=2.30.1-r0 \
        nginx=1.18.0-r13  \
        nodejs=14.16.0-r0 \
        npm=14.16.0-r0 \
        openssh-client=8.4_p1-r2 \
        patch=2.7.6-r6

RUN \
    chmod a+x /run.sh \
    \
    # Install bashio
    && apk add --no-cache \
    jq \
    curl \
    cifs-utils \
	nginx \
    \
    && mkdir -p /run/nginx \
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
# Allow UID and GID setting
    && sed -i 's/bash/bashio/g' /etc/cont-init.d/10-adduser \
    && sed -i 's/{PUID:-911}/(bashio::config "PUID")/g' /etc/cont-init.d/10-adduser \
    && sed -i 's/{PGID:-911}/(bashio::config "PGID")/g' /etc/cont-init.d/10-adduser \
# Correct visualization bug on mobile
    && sed -i 's|content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0"|content="width=980, initial-scale=1.0"|g' /app/scrutiny-web/index.html \
# use /data instead of /config for database
    && sed -i 's| /config| /data|g' /defaults/scrutiny.yaml \
    && sed -i 's| /config| /data|g' /etc/cont-init.d/* \
    && sed -i 's| /config| /data|g' /etc/logrotate.d/scrutiny \
    && sed -i 's| /config| /data|g' /etc/crontabs/root \
    && sed -i -e '$a @reboot /run.sh' /etc/crontabs/root \
    && sed -i -e '$a 0 * * * * /run.sh' /etc/crontabs/root

VOLUME [ "/data" ]
