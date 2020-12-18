ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

COPY rootfs /share/joal
RUN mv /share/joal/default.json /share/joal/config.json
RUN chown -R $(id -u):$(id -g) /share/joal
