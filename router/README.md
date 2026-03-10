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

## Backup

`backup.sh` pulls config from the router, deduplicates, and encrypts
with `age`. Only creates a new archive if content has changed.

What it captures:
- **sysupgrade backup** — all UCI config, SSH keys, crontabs, custom
  scripts listed in `/etc/sysupgrade.conf`
- **AdGuardHome config** — `/etc/AdGuardHome/config.yaml`
- **Installed packages** — `opkg list-installed` for reinstall after
  firmware upgrades

```bash
# One-time setup
brew install age
age-keygen -o ~/.config/age/key.txt
# Copy the public key line into the recipient file:
grep 'public key' ~/.config/age/key.txt | awk '{print $NF}' > ~/.config/age/recipient.txt

# Run backup
./backup.sh

# Decrypt a backup
age -d -i ~/.config/age/key.txt flint2-2026-03-07-1500.tar.gz.age | tar xzf -
```

Backups go to `~/backups/router/`. Automate with cron:
```bash
# Weekly Sunday 3am
0 3 * * 0  /path/to/dotfiles/router/backup.sh >> /tmp/router-backup.log 2>&1
```

## Persistence

`setup.sh` adds all files to `/etc/sysupgrade.conf` so they survive
firmware upgrades.
