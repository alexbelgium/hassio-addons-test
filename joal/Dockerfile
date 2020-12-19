ARG BUILD_FROM
FROM $BUILD_FROM

RUN mkdir p /data/joal \
    &&  curl -L -s \
        "https://github.com/anthonyraymond/joal/releases/download/2.1.24/joal.tar.gz" \
        | tar zxvf - -C /data/joal \
    && rm -fr \
        /tmp/joal.tar.gz
        
# COPY rootfs /data/joal
# RUN mv /data/joal/default.json /data/joal/config.json 
# RUN chown -R $(id -u):$(id -g) /data/joal

CMD [ "--joal-conf=/data/joal" ]
VOLUME [ "/data" ]
