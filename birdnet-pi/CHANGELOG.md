## 0.13-37 (20-05-2024)
- BREAKING CHANGE : the main port has changed from 80 to 8081 to allow ssl
- Not working yet : enable ssl access using either caddy's automated ssl (see Readme), or HomeAssistant's let's encrypt from the addon options
- [INGRESS] allow access to streamlit, logs

## 0.13-33 (19-05-2024)
- [INGRESS] Allow access to restricted area without password if authentificated from within the homeassistant app
- [SPECIES_CONVERTER] : fixed

## 0.13-31 (19-05-2024)
- [SPECIES_CONVERTER] : Significantly improve, add a webui when the option is enabled
- [SPECIES_CONVERTER] : Improve the SPECIES_CONVERTER webui with input text filtering in both browser and mobile

## 0.13-28 (17-05-2024)
- [SPECIES_CONVERTER] : New option ; if enabled, you need to put in the file /config/convert_species_list.txt the list of species you want to convert (example : Falco subbuteo_Faucon hobereau;Falco tinnunculus_Faucon Crécerelle). It will convert on the fly the specie when detected. This is not enabled by default as can be a cause for issues
- Improve code clarity by separating modifications of code to make it work, and new features specific to the addon

## 0.13-27 (15-05-2024)
- [CHANGE DETECTION] : Enable new feature to change detection from webui

## 0.13-25 (13-05-2024)
- Allow ssl using certificates generated by let's encrypt

## 0.13-24 (12-05-2024)
- Enable cron jobs

## 0.13-23 (11-05-2024)
- Improve throttle service
- Improve data recovery upon analyser stop

## 0.13-20 (02-05-2024)
- Minor bugs fixed

## 0.13-19 (02-05-2024)
- Fix : show container logs in "View log"
- Feat : new command line script to change the identification of a bird (changes database & files location)
- Fix : correct chmod defaults

## 0.13-17 (01-05-2024)
- Feat : Send service logs to docker container
- Feat : re-add the throttle service
- Feat : ensure no data from tpmfs is lost when the container is closed by saving it to a temporary place, and restoring on restart

## 0.13-11 (01-05-2024)
- Feat : use pi_password to define the user password from the addon options

## 0.13-8 (29-04-2024)
- Improve ingress
- Fix : give caddy UID 1000 to allow deletion of files owned by pi

## 0.13-5 (29-04-2024)
- Feat : addon option to use allaboutbird (US) or ebird (international) for additional birds info
- Remove throttle script due to interactions with analysis service

## 0.13 (28-04-2024)
- Fix : ensure correct labels language is used at boot
- Feat : add throttle recording service from @JohnButcher https://github.com/mcguirepr89/BirdNET-Pi/issues/393#issuecomment-1166445710
- Feat : use tmpfs from StreamData to reduce disk wear
- Feat : definition of BirdSongs folder through an addon option, existing data will not be migrated
- Add support for /config/include_species_list.txt and /config/exclude_species_list.txt
- Add support for apprise, txt, clean code
- Initial build
