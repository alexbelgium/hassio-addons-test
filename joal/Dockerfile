ARG BUILD_FROM
FROM $BUILD_FROM

COPY rootfs /data
RUN mv /data/default.json /data/config.json 
RUN chown -R $(id -u):$(id -g) /data

VOLUME [ "/data" ]
