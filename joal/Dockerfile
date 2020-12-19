ARG BUILD_FROM
FROM $BUILD_FROM
ENV PG_VERSION=2.1.24

RUN curl -J -L -o /download.tar.gz \
        "https://github.com/anthonyraymond/joal/releases/download/$PG_VERSION/joal.tar.gz" \
    &&  mkdir p /tmp \
    &&  mkdir p /data/joal \
    && tar zxvf \
        /download.tar.gz \
        --strip 1 -C /data/joal \
    && chown -R $(id -u):$(id -g) /data/joal
    && rm /download.tar.gz
      
# COPY rootfs /data/joal
# RUN mv /data/joal/default.json /data/joal/config.json 
# RUN chown -R $(id -u):$(id -g) /data/joal

CMD [ "--joal-conf=/data/joal" ]
VOLUME [ "/data" ]
