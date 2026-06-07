# Test repository

Scratch repository for testing Home Assistant add-ons. **Do not install in production.**

## Add-ons

- **birdnet-go (from source)** — same as the production [birdnet-go add-on](https://github.com/alexbelgium/hassio-addons/tree/master/birdnet-go), but compiles BirdNET-Go from the [`alexbelgium/birdnet-go`](https://github.com/alexbelgium/birdnet-go) fork. At build time it syncs the fork's `main` with the `tphakala/birdnet-go` upstream and merges every open non-draft pull request on the fly. Published as `ghcr.io/alexbelgium/birdnet-go-source-{arch}`.
