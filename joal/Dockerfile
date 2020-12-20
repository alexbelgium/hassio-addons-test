ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]
        
COPY rootfs /
RUN mv /data/joal/default.json /data/joal/config.json 
RUN chown -R $(id -u):$(id -g) /data/joal

# RUN mkdir p /data/joal2 \
#    &&  curl -L -s \
#        "https://github.com/anthonyraymond/joal/releases/download/2.1.24/joal.tar.gz" \
#        | tar zxvf - -C /data/joal2 \
#    && chown -R $(id -u):$(id -g) /data/joal2 \
#    && rm -fr \
#        /tmp/*


CMD [ "--joal-conf=/data/joal" ]
