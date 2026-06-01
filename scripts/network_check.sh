#!/bin/bash

# ==========================================
# Core Insight - Network Monitoring Module
# ==========================================

# Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "[NETWORK CHECK]"
echo "================================"

# Environment
OS=$(uname -s)

# Hostname
HOSTNAME=$(hostname)

# Timestamp
CURRENT_TIME=$(date)

# Target Host
TARGET="8.8.8.8"

# DNS Resolution Test
if getent hosts google.com >/dev/null 2>&1; then
    DNS_STATUS="OK"
else
    DNS_STATUS="FAILED"
fi

# Public IP Address
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me)

if [ -z "$PUBLIC_IP" ]; then
    PUBLIC_IP="Unavailable"
fi

# Perform Ping Test
PING_OUTPUT=$(ping -c 4 "$TARGET" 2>/dev/null)

# Check Connectivity
if [ $? -eq 0 ]; then

    STATUS="CONNECTED"
    COLOR=$GREEN

    PACKET_LOSS=$(echo "$PING_OUTPUT" | grep "packet loss" | awk -F',' '{print $3}' | xargs)

    AVG_LATENCY=$(echo "$PING_OUTPUT" | grep "rtt" | awk -F'/' '{print $5}')

    LATENCY_INT=$(printf "%.0f" "$AVG_LATENCY")

    if [ "$LATENCY_INT" -lt 50 ]; then
        QUALITY="EXCELLENT"
        QUALITY_COLOR=$GREEN

    elif [ "$LATENCY_INT" -lt 100 ]; then
        QUALITY="GOOD"
        QUALITY_COLOR=$YELLOW

    else
        QUALITY="POOR"
        QUALITY_COLOR=$RED
    fi

else

    STATUS="DISCONNECTED"
    COLOR=$RED

    PACKET_LOSS="100%"
    AVG_LATENCY="N/A"

    QUALITY="N/A"
    QUALITY_COLOR=$RED

    DNS_STATUS="FAILED"

fi

# Display Information
echo "Environment : $OS"
echo "Hostname    : $HOSTNAME"
echo "Time        : $CURRENT_TIME"

echo
echo "Network Information"
echo "-------------------"

echo "Target      : $TARGET"
echo -e "Status      : ${COLOR}${STATUS}${NC}"
echo "Packet Loss : $PACKET_LOSS"
echo "Avg Latency : ${AVG_LATENCY} ms"

if [ "$STATUS" = "CONNECTED" ]; then
    echo -e "Quality     : ${QUALITY_COLOR}${QUALITY}${NC}"
fi

echo "DNS Status  : $DNS_STATUS"
echo "Public IP   : $PUBLIC_IP"

# Alert Section
if [ "$STATUS" = "DISCONNECTED" ]; then

    echo -e "${RED}ALERT: Network connectivity lost!${NC}"

    "$(dirname "$0")"/mail_alert.sh \
    "Core Insight Network Alert" \
    "Network connectivity lost on ${HOSTNAME} at ${CURRENT_TIME}."

fi

echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] NETWORK=${STATUS} | LOSS=${PACKET_LOSS} | LATENCY=${AVG_LATENCY}ms | DNS=${DNS_STATUS} | IP=${PUBLIC_IP} | HOST=${HOSTNAME}" >> ../logs/monitor.log