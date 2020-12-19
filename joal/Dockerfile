ARG BUILD_FROM
FROM $BUILD_FROM
ENV PG_VERSION=2.1.24

RUN mkdir -p /data/joal \
    && curl -SL https://github.com/anthonyraymond/joal/releases/download/$PG_VERSION/joal.tar.gz \
    | tar -xJC /data/joal \
    && make -C /data/joal all

# COPY rootfs /data/joal
# RUN mv /data/joal/default.json /data/joal/config.json 
# RUN chown -R $(id -u):$(id -g) /data/joal

CMD [ "--joal-conf=/data/joal" ]
VOLUME [ "/data" ]
