
## 10.7.7-1-ls154 (11-03-2022)
- Update to latest version from linuxserver/docker-jellyfin

## 10.7.7-1-ls153 (05-03-2022)
- Update to latest version from linuxserver/docker-jellyfin

## 10.7.7-1-ls152 (24-02-2022)
- Update to latest version from linuxserver/docker-jellyfin

## 10.7.7-1-ls151 (17-02-2022)
- Update to latest version from linuxserver/docker-jellyfin

## 10.7.7-1-ls150 (20-01-2022)
- Update to latest version from linuxserver/docker-jellyfin
## 10.7.7-1-ls149 (15-01-2022)

- Update to latest version from linuxserver/docker-jellyfin
- "host_network": true to enable UPNP, chromecast, ...
- Code to repair database due to a bug that occured when the config location changed

## 10.7.7-1-ls148 (06-01-2022)

- Update to latest version from linuxserver/docker-jellyfin
- Cleanup: config base folder changed to /config/addons_config (thanks @bruvv)
- New standardized logic for Dockerfile build and packages installation
- Add local mount (see readme)
- Added watchdog feature
- Allow mounting of devices up to sdg2
- SMB : accepts several disks separated by commas mounted in /mnt/$sharename

## 10.7.7-1-ls130 (06-09-2021)

- Update to latest version from linuxserver/docker-jellyfin

## 10.7.6-1-ls118 (19-06-2021)

- Update to latest version from linuxserver/docker-jellyfin

## 10.7.5-1-ls113 (20-05-2021)

- Update to latest version from linuxserver/docker-jellyfin
- Add banner to log

## 10.7.5-1-ls112 (14-05-2021)

- Update to latest version from linuxserver/docker-jellyfin

## 10.7.5-1-ls111 (06-05-2021)

- Update to latest version from linuxserver/docker-jellyfin

## 10.7.2-1-ls110 (30-04-2021)

- Update to latest version from linuxserver/docker-jellyfin

## 10.7.2-1-ls109

- Update to latest version from linuxserver/docker-jellyfin
- Enables PUID/GUID options
- New feature : mount smb share in protected mode
- New feature : mount multiple smb shares
- New config/feature : mount smbv1
- Changed path : changed smb mount path from /storage/externalcifs to /mnt/$NAS name
- Removed feature : ability to remove protection and mount local hdd, to increase the addon score
