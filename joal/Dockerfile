ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

COPY rootfs /data
RUN chown -R $(id -u):$(id -g) /data
