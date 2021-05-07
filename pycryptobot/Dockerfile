ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

#Install last version https://github.com/dvershinin/lastversion
RUN \
    apk add --no-cache git moreutils \
    && pip install --upgrade pip \
	&& git clone https://github.com/whittlem/pycryptobot \
	&& cd pycryptobot \
	&& python3 -m pip install -r requirements.txt

# Copy script
COPY rootfs/ /
RUN chmod a+x /run.sh
CMD [ "/run.sh"] 

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
