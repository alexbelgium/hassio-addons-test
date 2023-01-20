# Home assistant add-on: MyElectricalData

[![Donate][donation-badge]](https://www.buymeacoffee.com/alexbelgium)

![Version](https://img.shields.io/badge/dynamic/json?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2Falexbelgium%2Fhassio-addons%2Fmaster%2Fenedisgateway2mqtt%2Fconfig.json)
![Ingress](https://img.shields.io/badge/dynamic/json?label=Ingress&query=%24.ingress&url=https%3A%2F%2Fraw.githubusercontent.com%2Falexbelgium%2Fhassio-addons%2Fmaster%2Fenedisgateway2mqtt%2Fconfig.json)
![Arch](https://img.shields.io/badge/dynamic/json?color=success&label=Arch&query=%24.arch&url=https%3A%2F%2Fraw.githubusercontent.com%2Falexbelgium%2Fhassio-addons%2Fmaster%2Fenedisgateway2mqtt%2Fconfig.json)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/9c6cf10bdbba45ecb202d7f579b5be0e)](https://www.codacy.com/gh/alexbelgium/hassio-addons/dashboard?utm_source=github.com&utm_medium=referral&utm_content=alexbelgium/hassio-addons&utm_campaign=Badge_Grade)
[![GitHub Super-Linter](https://github.com/alexbelgium/hassio-addons/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)
[![Builder](https://github.com/alexbelgium/hassio-addons/workflows/Builder/badge.svg)](https://github.com/alexbelgium/hassio-addons/actions/workflows/builder.yaml)

[donation-badge]: https://img.shields.io/badge/Buy%20me%20a%20coffee-%23d32f2f?logo=buy-me-a-coffee&style=flat&logoColor=white

_Thanks to everyone having starred my repo! To star it click on the image below, then it will be on top right. Thanks!_


[![Stargazers repo roster for @alexbelgium/hassio-addons](https://git-lister.onrender.com/api/stars/alexbelgium/hassio-addons?limit=30)](https://github.com/alexbelgium/hassio-addons/stargazers)

## About

Enedisgateway2mqtt use Enedis Gateway API to send data in your MQTT Broker.
See its github for all informations : https://github.com/m4dm4rtig4n/myelectricaldata

## Configuration

Install, then start the addon a first time to initialize the templates.

Options can be configured through two ways :

- Addon options

```yaml
CONFIG_LOCATION: /config/enedisgateway2mqtt/enedisgateway2mqtt.conf # Sets the location of the config.yaml (see below)
mqtt_autodiscover: true # Shows in the log the detail of the mqtt local server (if available). It can then be added to the config.yaml file.
TZ: Europe/Paris # Sets a specific timezone
```

- Config.yaml
  Everything is configured using the config.yaml file found in /config/enedisgateway2mqtt/enedisgateway2mqtt.conf.

The complete list of options can be seen here : https://github.com/m4dm4rtig4n/enedisgateway2mqtt#environment-variable

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add my Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install this add-on.
1. Click the `Save` button to store your configuration.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. Carefully configure the add-on to your preferences, see the official documentation for for that.

[repository]: https://github.com/alexbelgium/hassio-addons
