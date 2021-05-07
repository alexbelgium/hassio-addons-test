ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

#Install last version https://github.com/dvershinin/lastversion
RUN \
    apk add --no-cache git moreutils \
    && pip install --upgrade pip \
    && git clone https://github.com/edeng23/binance-trade-bot \
    && cd binance-trade-bot \
    && python3 -m pip install -r requirements.txt
 
# Copy files
COPY rootfs/ /binance-trade-bot/
RUN chmod a+x /binance-trade-bot/run.sh
WORKDIR [ "/binance-trade-bot" ] 
CMD [ "run.sh" ] 

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
