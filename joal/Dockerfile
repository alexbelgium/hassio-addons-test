ARG BUILD_FROM
FROM $BUILD_FROM

COPY rootfs /data/joal
RUN mv /data/joal/default.json /data/joal/config.json 
RUN chown -R $(id -u):$(id -g) /data/joal

VOLUME [ "/data" ]
CMD [--joal-conf=/share/joal]
