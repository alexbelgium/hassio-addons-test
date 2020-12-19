ARG BUILD_FROM
FROM $BUILD_FROM

COPY rootfs /data
RUN chown -R $(id -u):$(id -g) /data

VOLUME [ "/data" ]
