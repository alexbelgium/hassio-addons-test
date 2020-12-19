ARG BUILD_FROM
FROM $BUILD_FROM

RUN curl -J -L -o /tmp/download.tar.gz \
        "https://github.com/anthonyraymond/joal/releases/download/$PG_VERSION/joal.tar.gz" \
    &&  mkdir -p /data/joal \
    && tar zxvf /tmp/download.tar.gz -C /data/joal \
    && chown -R $(id -u):$(id -g) /data/joal \
    && rm /tmp/download.tar.gz
      
# COPY rootfs /data/joal
# RUN mv /data/joal/default.json /data/joal/config.json 
# RUN chown -R $(id -u):$(id -g) /data/joal

CMD [ "--joal-conf=/data/joal" ]
VOLUME [ "/data" ]
