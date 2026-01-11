# Karakeep WireGuard add-on

Run [Karakeep](https://github.com/karakeep-app/karakeep) with an embedded Chromium browser whose outbound traffic can be routed through WireGuard. The Chromium profile persists under `/data`, so GDPR consent cookies and logins survive restarts.

> **Important:** This add-on does **not** bypass captchas or automate solving them. If a site requires a captcha, you can enable the optional interactive mode and solve it manually. Cookies and localStorage will then persist for future runs.

## Features

- Karakeep web UI + workers + Meilisearch in one add-on.
- Remote Chromium DevTools endpoint with persistent profile storage.
- Optional interactive browser mode with noVNC for manual consent/captcha handling.
- WireGuard client with optional kill switch and diagnostics.
- PUID/PGID ownership fixes in `/data`.

## Configuration

Example configuration:

```yaml
PUID: 1000
PGID: 1000
log_level: info
karakeep_port: 3000
karakeep_nextauth_url: "https://karakeep.example.com"
karakeep_meili_master_key: ""
karakeep_nextauth_secret: ""

browser_enable: true
browser_headless: true
browser_remote_debug_port: 9222
browser_interactive_enable: false
browser_novnc_port: 6080
browser_warmup_urls:
  - "https://example.com"

wireguard_enable: true
wireguard_private_key: "<private key>"
wireguard_address:
  - "10.6.0.2/32"
wireguard_dns:
  - "1.1.1.1"
wireguard_peers:
  - public_key: "<peer public key>"
    endpoint: "vpn.example.com:51820"
    allowed_ips:
      - "0.0.0.0/0"
      - "::/0"
    persistent_keepalive: 25
wireguard_killswitch: true
wireguard_lan_subnets:
  - "172.30.32.0/23"
  - "192.168.1.0/24"
wireguard_mtu: 0
diagnostics_enable: false
```

### Options

- `karakeep_nextauth_url`: Required for correct auth callbacks. Leave empty to auto-generate `http://homeassistant.local:<port>`.
- `karakeep_meili_master_key` and `karakeep_nextauth_secret`: Leave empty to auto-generate and persist in `/data/karakeep.env`.
- `browser_warmup_urls`: Optional list of URLs Chromium will open on startup (navigation only).
- `wireguard_killswitch`: When enabled, blocks all non-tunnel egress except WireGuard endpoint and configured LAN subnets.

## WireGuard behavior

- If WireGuard is enabled and fails to start:
  - With kill switch **on**: the add-on exits.
  - With kill switch **off**: it logs a warning and runs without the tunnel.
- DNS servers supplied in `wireguard_dns` are applied to `/etc/resolv.conf` while the add-on is running.

## Browser modes

### Default (headless)

The add-on starts Chromium in headless mode and exposes a DevTools endpoint on `browser_remote_debug_port`. Karakeep uses this endpoint for previews and rendering.

### Interactive mode (noVNC)

Enable `browser_interactive_enable: true` and browse to `http://<addon-host>:<browser_novnc_port>` to access the interactive session:

1. Enable interactive mode.
2. Open the noVNC URL.
3. Accept GDPR banners or log in manually.
4. Disable interactive mode.

Because the Chromium profile is stored in `/data/browser-profile`, cookies and localStorage persist across restarts.

## Data locations

- Karakeep data: `/data/karakeep`
- Meilisearch data: `/data/meilisearch`
- Chromium profile: `/data/browser-profile`
- Generated secrets: `/data/karakeep.env`

## Troubleshooting

- **`/dev/net/tun` missing**: Ensure the add-on has access to the TUN device and `NET_ADMIN` capability.
- **iptables errors**: Make sure the host supports iptables/nftables and the add-on has `NET_ADMIN`.
- **DNS leaks**: Provide `wireguard_dns` and enable kill switch for strict routing.
- **MTU issues**: Set `wireguard_mtu` when you see connection stalls or partial page loads.
- **Profile not persisting**: Confirm `/data/browser-profile` ownership matches PUID/PGID.

## Design notes

Persistent browser profiles reduce GDPR overlays because consent cookies and localStorage survive restarts. WireGuard egress provides a stable public IP, which can reduce anti-bot challenges tied to IP churn. This add-on does **not** bypass captcha challenges; interactive mode exists only for manual completion.
