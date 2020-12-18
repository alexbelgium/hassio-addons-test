ARG BUILD_FROM
FROM $BUILD_FROM

# RUN
RUN java -jar /data/jack-of-all-trades-2.0.4.jar --joal-conf="/data/config.json" --spring.main.web-environment=true --server.port=8081

VOLUME [ "/data" ]
