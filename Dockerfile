
FROM forumi0721/alpine-nodejs:latest

RUN \
# Install git
apk update && apk add -y git
RUN mkdir /src
RUN git clone https://github.com/furier/websync \
    && mv furier/websync/* /src
RUN cd /src; npm install
EXPOSE  3000
CMD ["node", "/src/server.js"]
