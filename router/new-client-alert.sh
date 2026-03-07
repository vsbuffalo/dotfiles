#!/bin/sh
# new-client-alert.sh — dnsmasq DHCP hook for unknown device alerts
#
# Called by dnsmasq via GL.iNet's USER_DHCPSCRIPT mechanism.
# Sends a Pushover notification when an unknown MAC address
# appears in a DHCP add or old (renewal) event.
#
# Install:
#   uci set dhcp.@dnsmasq[0].dhcpscript='/root/new-client-alert.sh'
#   uci commit dhcp
#   /etc/init.d/dnsmasq restart
#
# Requires /root/.pushover_creds with PO_TOKEN and PO_USER

. /root/.pushover_creds

ACTION=$1
MAC=$2
IP=$3
HOSTNAME=$4

KNOWN_CLIENTS="/root/known_clients.txt"

logger -t dhcp-hook "Script called: action=$ACTION mac=$MAC ip=$IP hostname=$HOSTNAME"

if [ "$ACTION" = "add" ] || [ "$ACTION" = "old" ]; then
    if ! grep -qi "$MAC" "$KNOWN_CLIENTS" 2>/dev/null; then
        MSG="New device on network: MAC=$MAC IP=$IP hostname=${HOSTNAME:-unknown}"
        logger -t dhcp-hook "Unknown device! Sending alert: $MSG"
        curl -s --form-string "token=$PO_TOKEN" \
               --form-string "user=$PO_USER" \
               --form-string "message=$MSG" \
               --form-string "title=Flint2: New Device" \
               --form-string "priority=2" \
               --form-string "retry=60" \
               --form-string "expire=3600" \
               https://api.pushover.net/1/messages.json
        logger -t dhcp-hook "Alert sent"
    fi
fi
