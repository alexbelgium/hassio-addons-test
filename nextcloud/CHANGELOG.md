## 25.0.3 (12-02-2023)

- WARNING! : this is a major code update. Make sure to have a full update of /config, /share and your nextcloud addon before updating. I take no responsibility for lost data!
- Update to latest version from linuxserver/docker-nextcloud
- WARNING : update to supervisor 2022.11 before installing

## 25.0.0 (20-10-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 24.0.6 (08-10-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 24.0.5 (09-09-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 24.0.4 (13-08-2022)

- Update to latest version from linuxserver/docker-nextcloud
- Allow installation of custom apk files with parameter "additional_apps"

## 24.0.3 (19-07-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 24.0.2 (21-06-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 24.0.1 (24-05-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 23.0.4 (22-04-2022)

- Update to latest version from linuxserver/docker-nextcloud
- Fix : correct bug preventing start
- Add codenotary sign

## 23.0.3 (22-03-2022)

- Update to latest version from linuxserver/docker-nextcloud

## 23.0.2 (16-02-2022)

- Update to latest version from linuxserver/docker-nextcloud
- Automatic mount of local and smb mounts (see readme)
- New "Data directory" option that allows to define the folder where data are stored
- Provides MariaDB addon information to use it as database on first installation
- MultiOCR: in OCRLANG field use comma separated value. Ex: fra,deu
- Max file size increased to 10Go
- New standardized logic for Dockerfile build and packages installation

## 23.0.0 (30-11-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 22.2.3 (16-11-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 22.2.2 (13-11-2021)

- Update to latest version from linuxserver/docker-nextcloud
- Repaired use own certs
- Repaired increment of trusted domains
- Repaired setting OCR language
- New optional config : enable elasticsearch (requires to run in parallel elasticsearch addon)
- Repaired default data setting in /share/nextcloud

## 22.2.0 (02-10-2021)

- Update to latest version from linuxserver/docker-nextcloud
- Faster reboot by only chowning files if user change
- BREAKING CHANGE : comma separated domains instead of list
- Allow usage of own certificates
- OCR fixed
- glibc compatibility added

## 22.1.1 (31-08-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 22.1.0 (07-08-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 22.0.0 (07-07-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 21.0.3 (02-07-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 21.0.2 (20-05-2021)

- Update to latest version from linuxserver/docker-nextcloud

## 21.0.1

- Update to latest version from linuxserver/docker-nextcloud

## 21.0.0

- Update to latest version from linuxserver/docker-nextcloud
- Enables PUID/PGID options
