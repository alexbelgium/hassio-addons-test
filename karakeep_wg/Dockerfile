ARG BUILD_FROM=ghcr.io/karakeep-app/karakeep:release
FROM ${BUILD_FROM}

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

ARG TARGETARCH
ARG MEILISEARCH_VERSION=1.13.3

RUN apk add --no-cache \
    bash \
    curl \
    iproute2 \
    iptables \
    jq \
    openssl \
    tzdata \
    wireguard-tools \
    chromium \
    xvfb \
    x11vnc \
    novnc \
    websockify

RUN mkdir -p /usr/lib/bashio \
    && curl -fsSL https://github.com/hassio-addons/bashio/archive/refs/heads/main.tar.gz \
      | tar xz --strip-components=2 -C /usr/lib/bashio bashio-main/lib

RUN case "${TARGETARCH}" in \
        "amd64") meili_arch="linux-amd64" ;; \
        "arm64") meili_arch="linux-aarch64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/meilisearch \
      "https://github.com/meilisearch/meilisearch/releases/download/v${MEILISEARCH_VERSION}/meilisearch-${meili_arch}" \
    && chmod 755 /usr/local/bin/meilisearch

COPY rootfs /

RUN chmod 755 \
    /etc/cont-init.d/00-setup.sh \
    /etc/cont-init.d/10-wireguard.sh \
    /etc/cont-init.d/20-karakeep-env.sh \
    /etc/cont-init.d/30-db-migrate.sh \
    /etc/services.d/karakeep/run \
    /etc/services.d/karakeep-worker/run \
    /etc/services.d/meilisearch/run \
    /etc/services.d/browser/run

ENV DATA_DIR=/data/karakeep
ENV MEILI_ADDR=http://127.0.0.1:7700
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
