#!/bin/bash

# ==========================================
# Core Insight - Disk Monitoring Module
# ==========================================

# Load Configuration
source ../configs/threshold.conf

# Validate Configuration
if [ -z "$DISK_THRESHOLD" ]; then
    echo "ERROR: DISK_THRESHOLD not found in threshold.conf"
    exit 1
fi

# Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "[DISK CHECK]"
echo "================================"

# Environment Detection
OS=$(uname -s)

# Hostname
HOSTNAME=$(hostname)

# Timestamp
CURRENT_TIME=$(date)

# Disk Information
TOTAL_DISK=$(df -h / | awk 'NR==2 {print $2}')
USED_DISK=$(df -h / | awk 'NR==2 {print $3}')
FREE_DISK=$(df -h / | awk 'NR==2 {print $4}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Status Evaluation
if [ "$DISK_USAGE" -lt 50 ]; then
    STATUS="NORMAL"
    COLOR=$GREEN

elif [ "$DISK_USAGE" -lt "$DISK_THRESHOLD" ]; then
    STATUS="WARNING"
    COLOR=$YELLOW

else
    STATUS="CRITICAL"
    COLOR=$RED
fi

# Display Information
echo "Environment : $OS"
echo "Hostname    : $HOSTNAME"
echo "Time        : $CURRENT_TIME"
echo "Disk Total  : $TOTAL_DISK"
echo "Disk Used   : $USED_DISK"
echo "Disk Free   : $FREE_DISK"
echo "Disk Usage  : ${DISK_USAGE}%"
echo "Threshold   : ${DISK_THRESHOLD}%"

echo -e "Status      : ${COLOR}${STATUS}${NC}"

# Alert Section
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then

    echo -e "${RED}ALERT: Disk threshold exceeded!${NC}"

    "$(dirname "$0")"/mail_alert.sh \
    "Core Insight Disk Alert" \
    "Disk usage reached ${DISK_USAGE}% on ${HOSTNAME} at ${CURRENT_TIME}. Threshold is ${DISK_THRESHOLD}%."

fi

echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] DISK=${DISK_USAGE}% | Status=${STATUS} | Host=${HOSTNAME} | OS=${OS}" >> ../logs/monitor.log