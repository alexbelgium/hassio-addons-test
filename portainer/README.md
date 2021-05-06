# Home assistant add-on: Portainer
![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield]

## About

Portainer CE - Making Docker and Kubernetes Management Easy
This addon is based on the [docker image](https://hub.docker.com/r/portainer/portainer-ce).

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add my Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install this add-on.
1. Click the `Save` button to store your configuration.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. Carefully configure the add-on to your preferences, see the official documentation for for that.

## Configuration
Webui can be found at <http://your-ip:1337>.

```yaml
ssl: true/false
certfile: fullchain.pem #ssl certificate
keyfile: privkey.pem #sslkeyfile
smbv1: false # Should smbv1 be used instead of 2.1+?
networkdisks: "//SERVER/SHARE" # optional, list of smbv2/3 servers to mount, separated by commas
cifsusername: "username" # optional, smb username, same for all smb shares
cifspassword: "password" # optional, smb password, same for all smb shares)
```

## Support
Create an issue on github

[repository]: https://github.com/alexbelgium/hassio-addons
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
