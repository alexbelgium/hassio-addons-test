ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

COPY rootfs /
RUN mv /data/default.json /data/config.json
RUN chown -R $(id -u):$(id -g) /data
