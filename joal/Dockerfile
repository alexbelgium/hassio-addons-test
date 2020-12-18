ARG BUILD_FROM
FROM $BUILD_FROM

# RUN
RUN java -jar /joal/joal.jar --joal-conf="/joal/config.json" --spring.main.web-environment=true --server.port=8081

VOLUME [ "/data" ]
