#!/bin/bash

# ==========================================
# Core Insight - Uptime Monitoring Module
# ==========================================

# Terminal Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo "================================"
echo "[UPTIME CHECK]"
echo "================================"

# Environment
OS=$(uname -s)

# Hostname
HOSTNAME=$(hostname)

# Timestamp
CURRENT_TIME=$(date)

# System Uptime
UPTIME_PRETTY=$(uptime -p)

# Boot Time
BOOT_TIME=$(who -b 2>/dev/null | awk '{print $3, $4}')

# Fallback if who -b fails
if [ -z "$BOOT_TIME" ]; then
    BOOT_TIME=$(uptime -s 2>/dev/null)
fi

# Load Averages
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')

# Display Information
echo "Environment : $OS"
echo "Hostname    : $HOSTNAME"
echo "Time        : $CURRENT_TIME"

echo
echo "System Information"
echo "------------------"

echo "System Uptime : $UPTIME_PRETTY"
echo "Boot Time     : $BOOT_TIME"
echo "Load Average  : $LOAD_AVG"

echo
echo -e "Status        : ${GREEN}RUNNING${NC}"

echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] UPTIME CHECK | HOST=$HOSTNAME | UPTIME='$UPTIME_PRETTY'" >> ../logs/monitor.log