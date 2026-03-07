# Router — GL.iNet Flint2 (GL-MT6000)

Home router running OpenWrt. Chose the Flint2 for its OpenWrt/Linux
underpinnings — full shell access, opkg packages, uci config, standard
cron and scripting. Ubiquiti is a step up in price with decoupled hardware
(separate gateway, switch, APs), but the Flint2 hits a sweet spot for a
single-box setup you can actually SSH into and hack on.

## DHCP Alerting

Unknown device alerts via Pushover notifications.

## What it does

When an unknown MAC address appears on the network (DHCP add/renewal),
`new-client-alert.sh` sends a Pushover notification. Known devices are
whitelisted in `known_clients.txt`.

## Files

| File | Deploys to | Purpose |
|------|-----------|---------|
| `new-client-alert.sh` | `/root/` | dnsmasq DHCP hook script |
| `setup.sh` | run once | Configures dnsmasq, permissions, sysupgrade persistence |
| `pushover_creds.example` | `/root/.pushover_creds` | Credential template (fill in real tokens) |
| `known_clients.txt.example` | `/root/known_clients.txt` | MAC allowlist template |

## Deploy

```bash
# Copy files to router
scp new-client-alert.sh setup.sh pushover_creds.example known_clients.txt.example root@192.168.8.1:/root/

# SSH in and set up
ssh root@192.168.8.1
cp pushover_creds.example .pushover_creds
vi .pushover_creds          # fill in real tokens
cp known_clients.txt.example known_clients.txt
vi known_clients.txt         # add your MACs
sh setup.sh
```

## Test

```bash
/root/new-client-alert.sh add AA:BB:CC:DD:EE:FF 192.168.8.99 testdevice
```

## Persistence

`setup.sh` adds all files to `/etc/sysupgrade.conf` so they survive
firmware upgrades.
