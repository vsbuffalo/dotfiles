# Tailscale — Quick Start

> **Goal:** Secure, private connectivity (and SSH) between my Macs — no public ports, no NAT headaches.

---

## What is Tailscale?

Tailscale is a *mesh* virtual‑private network that automatically builds an
**encrypted, peer‑to‑peer WireGuard network** between all of registered. What
is WireGuard? It's a minimalist VPN protocol that uses modern crypto
(ChaCha20‑Poly1305) and runs in the kernel, giving near‑line‑speed encryption
and simple key handling. Every device joins the *tailnet* with a single sign‑in
and gets a stable, private IP (100.x.x.x).

Because every tunnel is outbound‑initiated, you never have to punch holes in
your firewall or set up port‑forwarding: SSH, RDP, file sync—whatever service
you expose—travels inside the WireGuard tunnel and your router stays invisible
to internet scans.

Tailscale gives automatic key rotation, Access Control List (ACL) enforcement,
detailed audit in the admin console.

---

## Install on macOS (Homebrew)

```bash
# 1 Install the Tailscale formula (CLI + daemon)
brew install tailscale

# 2 Install & load the root LaunchDaemon so SSH can work
sudo tailscaled install-system-daemon

# 3 Bring the interface up and enable the built‑in SSH server
sudo tailscale up --ssh                 # opens browser → sign in once
```

After step 3 you’ll see **“Success. Logged in as you@…”** and the menu‑bar icon
turns solid.

---

## First‑time checks

```bash
tailscale status
```

From any other Tailscale device:

```bash
ssh <your‑mac‑user>@macstudio     # or use its 100.x.x.x address
```

---

## Optional recommended manual tweaks

| Need                                       | How                                                                                                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Disallow root logins**                   | In Admin Console → *Access Controls*, add an ACL like:`{"action":"accept","src":["you@example.com"],"dst":["macstudio:22"],"users":["unix:vsb"]}` |
| **Restrict who can connect**               | Use ACL `src` rules or tag the Mac (e.g. `tag:server`) and allow only certain users/devices.                                                      |
| **Stop accepting subnet/exit‑node routes** | Run `sudo tailscale up --reset --ssh` and omit `--accept-routes`.                                                                                 |

---

## Uninstall or upgrade

```bash
# Stop & remove the LaunchDaemon
sudo launchctl bootout system /Library/LaunchDaemons/com.tailscale.tailscaled.plist

# Remove with Homebrew
brew uninstall tailscale
```

Future upgrades are simple:

```bash
brew upgrade tailscale
```

