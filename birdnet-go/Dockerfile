# syntax=docker/dockerfile:1
#============================#
#  ALEXBELGIUM'S DOCKERFILE  #
#  BirdNET-Go (from source)  #
#============================#
#           _.------.
#       _.-`    ('>.-`"""-.
# '.--'`       _'`   _ .--.)
#    -'         '-.-';`   `
#    ' -      _.'  ``'--.
#        '---`    .-'""`
#               /`
#=== Home Assistant Addon ===#
#
# This is the same Home Assistant add-on as the standard alexbelgium/birdnet-go
# add-on, EXCEPT that the BirdNET-Go binary is compiled from the
# alexbelgium/birdnet-go fork instead of pulling the prebuilt
# ghcr.io/tphakala/birdnet-go image.
#
# Before compiling, "merge-prs.sh" clones the fork, fast-forwards its main onto
# the tphakala/birdnet-go upstream (so main is fully synced with upstream) and
# merges every OPEN, NON-DRAFT ("in review") pull request on the fly. The Home
# Assistant integration layers (sections 2-6 below) are then applied on top and
# are byte-for-byte identical to the upstream-image variant.
#
# Build stages 0-1 mirror tphakala/birdnet-go's Docker/Dockerfile; if upstream
# changes its build (Go/Node/onnxruntime versions, task names) sync them here.

##########################################################
# 0  Prepare merged BirdNET-Go source tree (fork + PRs)  #
##########################################################

FROM alpine/git:latest AS birdnet-source
ARG BIRDNET_FORK=alexbelgium/birdnet-go
ARG BIRDNET_UPSTREAM=tphakala/birdnet-go
# BUILD_DATE changes on every CI run, busting this layer's cache so the fork is
# re-cloned and the open PRs are re-merged "on the fly" on every build.
ARG BUILD_DATE=unknown
RUN apk add --no-cache bash curl jq
COPY merge-prs.sh /usr/local/bin/merge-prs.sh
RUN chmod +x /usr/local/bin/merge-prs.sh && \
    echo "Build date marker: ${BUILD_DATE}" && \
    BIRDNET_FORK="${BIRDNET_FORK}" BIRDNET_UPSTREAM="${BIRDNET_UPSTREAM}" \
    /usr/local/bin/merge-prs.sh /birdnet-src

#########################################################################
# 1a Build environment (mirrors tphakala/birdnet-go Docker/Dockerfile)  #
#########################################################################

FROM --platform=$BUILDPLATFORM golang:1.26-trixie AS buildenv
ARG BUILD_VERSION
ENV BUILD_VERSION=${BUILD_VERSION:-unknown}
ENV OPENVINO=true

# Install Task and other dependencies
RUN apt-get update -q && apt-get install -q -y \
    curl \
    git \
    sudo \
    zip \
    gcc-aarch64-linux-gnu && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js v24 from NodeSource
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Task
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Create dev-user for building
RUN groupadd --gid 10001 dev-user && \
    useradd --uid 10001 --gid dev-user --shell /bin/bash --create-home dev-user && \
    usermod -aG sudo dev-user && \
    usermod -aG audio dev-user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    mkdir -p /home/dev-user/src && \
    mkdir -p /home/dev-user/lib && \
    mkdir -p /home/dev-user/.cache && \
    mkdir -p /home/dev-user/.npm && \
    chown -R dev-user:dev-user /home/dev-user

USER dev-user
WORKDIR /home/dev-user/src/BirdNET-Go

# Bring in the merged source tree (fork main + upstream sync + open PRs)
COPY --from=birdnet-source --chown=dev-user /birdnet-src ./

# Pre-build frontend once in the shared buildenv stage
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN task frontend-build

##################
# 1b Build stage #
##################

FROM --platform=$BUILDPLATFORM buildenv AS build
ARG BUILD_VERSION
ENV BUILD_VERSION=${BUILD_VERSION:-unknown}
ARG TARGETPLATFORM
ARG ONNXRUNTIME_VERSION=1.25.1

# Download ONNX Runtime for the target platform
RUN ONNX_ARCH=$(case "${TARGETPLATFORM}" in \
        "linux/amd64") echo "x64" ;; \
        "linux/arm64") echo "aarch64" ;; \
        *) echo "Error: unsupported platform ${TARGETPLATFORM}" >&2; exit 1 ;; \
    esac) && \
    echo "Downloading ONNX Runtime ${ONNXRUNTIME_VERSION} for ${ONNX_ARCH}" && \
    curl -fsSL "https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_VERSION}/onnxruntime-linux-${ONNX_ARCH}-${ONNXRUNTIME_VERSION}.tgz" \
        -o /tmp/onnxruntime.tgz && \
    mkdir -p /tmp/onnxruntime && \
    tar -xzf /tmp/onnxruntime.tgz -C /tmp/onnxruntime --strip-components=1 && \
    cp /tmp/onnxruntime/lib/libonnxruntime*.so* /home/dev-user/lib/ && \
    rm -rf /tmp/onnxruntime /tmp/onnxruntime.tgz

# Build assets and compile BirdNET-Go (non-embedded, TFLite + ONNX)
RUN --mount=type=cache,target=/go/pkg/mod,uid=10001,gid=10001 \
    --mount=type=cache,target=/home/dev-user/.cache/go-build,uid=10001,gid=10001 \
    task check-tensorflow && \
    TARGET=$(echo ${TARGETPLATFORM} | tr '/' '_') && \
    echo "Building non-embedded version with BUILD_VERSION=${BUILD_VERSION}" && \
    BUILD_VERSION="${BUILD_VERSION}" DOCKER_LIB_DIR=/home/dev-user/lib task noembed_${TARGET}

#####################################################
# 1c BirdNET-Go runtime base (mirrors upstream)     #
#####################################################

FROM debian:trixie-slim AS birdnet-runtime

# Copy model files to /models directory as separate cacheable layer
RUN mkdir -p /models
COPY --from=build /home/dev-user/src/BirdNET-Go/internal/classifier/data/*.tflite /models/
RUN chmod -R a+r /models/*.tflite 2>/dev/null || true
RUN chmod a+x /models

# Install ALSA library and SOX for audio processing and system utilities
RUN apt-get update -q && apt-get install -q -y --no-install-recommends \
    adduser \
    ca-certificates \
    libasound2 \
    ffmpeg \
    sox \
    libsox-fmt-mp3 \
    procps \
    iproute2 \
    net-tools \
    curl \
    wget \
    nano \
    vim \
    less \
    tzdata \
    tzdata-legacy \
    jq \
    strace \
    lsof \
    bash-completion \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Set TFLITE_LIB_DIR (native builds resolve to /usr/lib for both arches)
ARG TARGETPLATFORM
ARG TFLITE_LIB_DIR=/usr/lib
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        echo "Building for arm64, using TFLITE_LIB_DIR=${TFLITE_LIB_DIR}"; \
    else \
        echo "Building for amd64, using TFLITE_LIB_DIR=${TFLITE_LIB_DIR}"; \
    fi

# Copy TensorFlow Lite library from build stage
COPY --from=build /home/dev-user/lib/libtensorflowlite_c.so* ${TFLITE_LIB_DIR}/

# Copy ONNX Runtime libraries from build stage
COPY --from=build /home/dev-user/lib/libonnxruntime*.so* /usr/lib/
RUN ldconfig

# Include reset_auth tool from build stage
COPY --from=build /home/dev-user/src/BirdNET-Go/reset_auth.sh /usr/bin/
RUN chmod +x /usr/bin/reset_auth.sh

# Add entrypoint and startup wrapper scripts from build stage
COPY --from=build /home/dev-user/src/BirdNET-Go/Docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
COPY --from=build /home/dev-user/src/BirdNET-Go/Docker/startup-wrapper.sh /usr/bin/
RUN chmod +x /usr/bin/startup-wrapper.sh

# Create config and data directories with permissions for rootless compatibility
RUN mkdir -p /config /data/clips /data/models && \
    chmod 777 /config /data /data/clips /data/models

# Install the freshly built BirdNET-Go binary
COPY --from=build /home/dev-user/src/BirdNET-Go/bin /usr/bin/

#============================================================================#
# From here on, the Home Assistant integration layers are identical to the   #
# standard alexbelgium/birdnet-go add-on (which builds FROM the prebuilt      #
# upstream image). The only difference above is that the base is compiled     #
# from the fork + open PRs rather than pulled from ghcr.io/tphakala.          #
#============================================================================#

##################
# 2 Modify Image #
##################

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set S6 wait time
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

##################
# 3 Install apps #
##################

# Add rootfs
COPY rootfs/ /
RUN find . -type f \( -name "*.sh" -o -name "run" -o -name "finish" \) -print -exec chmod +x {} \;

# Silence "chmod: Read-only file system" noise from upstream entrypoint:
# Home Assistant mounts /dev/snd read-only, so the chmod is a no-op and the
# stderr output is just noise. The "|| true" already absorbs the exit code.
# Warn (without failing the build) if the upstream pattern drifts so we notice
# in CI logs and can update the patch.
RUN if [ -f /usr/bin/entrypoint.sh ]; then \
        if grep -q 'chmod -R a+rw /dev/snd || true' /usr/bin/entrypoint.sh; then \
            sed -i 's#chmod -R a+rw /dev/snd || true#chmod -R a+rw /dev/snd 2>/dev/null || true#' /usr/bin/entrypoint.sh; \
        else \
            echo "WARN: upstream entrypoint.sh /dev/snd chmod pattern not found; nightly drift?" >&2; \
        fi; \
    fi

# Uses /bin for compatibility purposes
# hadolint ignore=DL4005
RUN if [ ! -f /bin/sh ] && [ -f /usr/bin/sh ]; then ln -s /usr/bin/sh /bin/sh; fi && \
    if [ ! -f /bin/bash ] && [ -f /usr/bin/bash ]; then ln -s /usr/bin/bash /bin/bash; fi

# Modules
ARG MODULES="00-local_mounts.sh 00-smb_mounts.sh"

# Automatic modules download
COPY ha_automodules.sh /ha_automodules.sh
RUN chmod 744 /ha_automodules.sh && /ha_automodules.sh "$MODULES" && rm /ha_automodules.sh

# Manual apps
ENV PACKAGES="alsa-utils libasound2-plugins nginx yq"

# Automatic apps & bashio
COPY ha_autoapps.sh /ha_autoapps.sh
RUN chmod 744 /ha_autoapps.sh && /ha_autoapps.sh "$PACKAGES" && rm /ha_autoapps.sh

################
# 4 Entrypoint #
################

# Add entrypoint
ENV S6_STAGE2_HOOK=/ha_entrypoint.sh
COPY ha_entrypoint.sh /ha_entrypoint.sh
RUN chmod 777 /ha_entrypoint.sh

# Install bashio
COPY bashio-standalone.sh /usr/local/lib/bashio-standalone.sh
RUN chmod 0755 /usr/local/lib/bashio-standalone.sh

# Avoid config.yaml interference
RUN sed -i "s|config.yaml|config_env.yaml|g" /etc/cont-init.d/01-config_yaml.sh
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

#################
# 6 Healthcheck #
#################

# Avoid spamming logs
# hadolint ignore=SC2016
RUN \
    # Handle Apache configuration
    if [ -d /etc/apache2/sites-available ]; then \
        for file in /etc/apache2/sites-*/*.conf; do \
            sed -i '/<VirtualHost/a \ \n    # Match requests with the custom User-Agent "HealthCheck" \n    SetEnvIf User-Agent "HealthCheck" dontlog \n    # Exclude matching requests from access logs \n    CustomLog ${APACHE_LOG_DIR}/access.log combined env=!dontlog' "$file"; \
        done; \
    fi && \
    \
    # Handle Nginx configuration
    if [ -f /etc/nginx/nginx.conf ]; then \
        awk '/http \{/{print; print "map $http_user_agent $dontlog {\n  default 0;\n  \"~*HealthCheck\" 1;\n}\naccess_log /var/log/nginx/access.log combined if=$dontlog;"; next}1' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.new && \
        mv /etc/nginx/nginx.conf.new /etc/nginx/nginx.conf; \
    fi
