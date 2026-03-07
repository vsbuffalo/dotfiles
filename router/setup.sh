#!/bin/sh
# setup.sh — configure dnsmasq DHCP hook and sysupgrade persistence
# Run on the router after copying scripts to /root/

set -e

echo "==> Checking prerequisites..."

if [ ! -f /root/.pushover_creds ]; then
    echo "ERROR: /root/.pushover_creds not found."
    echo "Copy pushover_creds.example to /root/.pushover_creds and fill in real tokens."
    exit 1
fi

if [ ! -f /root/new-client-alert.sh ]; then
    echo "ERROR: /root/new-client-alert.sh not found."
    exit 1
fi

if [ ! -f /root/known_clients.txt ]; then
    echo "WARNING: /root/known_clients.txt not found. Creating empty file."
    echo "# Add trusted device MACs here" > /root/known_clients.txt
fi

echo "==> Setting permissions..."
chmod +x /root/new-client-alert.sh
chmod 600 /root/.pushover_creds

echo "==> Configuring dnsmasq DHCP hook..."
uci set dhcp.@dnsmasq[0].dhcpscript='/root/new-client-alert.sh'
uci commit dhcp

echo "==> Adding files to sysupgrade.conf for firmware persistence..."
for f in /root/.pushover_creds /root/known_clients.txt /root/new-client-alert.sh; do
    if ! grep -qF "$f" /etc/sysupgrade.conf 2>/dev/null; then
        echo "$f" >> /etc/sysupgrade.conf
    fi
done

echo "==> Restarting dnsmasq..."
/etc/init.d/dnsmasq stop
sleep 2
/etc/init.d/dnsmasq start

echo "==> Testing Pushover connectivity..."
. /root/.pushover_creds
RESULT=$(curl -s --form-string "token=$PO_TOKEN" \
               --form-string "user=$PO_USER" \
               --form-string "message=Flint2 DHCP alerting configured successfully" \
               --form-string "title=Flint2: Setup Complete" \
               https://api.pushover.net/1/messages.json)

if echo "$RESULT" | grep -q '"status":1'; then
    echo "==> Setup complete! Pushover test notification sent."
else
    echo "WARNING: Pushover test failed. Check credentials in /root/.pushover_creds"
    echo "Response: $RESULT"
fi

echo ""
echo "To test unknown device alerting:"
echo "  /root/new-client-alert.sh add AA:BB:CC:DD:EE:FF 192.168.8.99 testdevice"
