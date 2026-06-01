#!/bin/bash

# ==========================================
# Core Insight - RAM Monitoring Module
# ==========================================

# Load Configuration
source ../configs/threshold.conf

# Validate Configuration
if [ -z "$RAM_THRESHOLD" ]; then
    echo "ERROR: RAM_THRESHOLD not found in threshold.conf"
    exit 1
fi

# Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "[RAM CHECK]"
echo "================================"

# Environment
OS=$(uname -s)

# Timestamp
CURRENT_TIME=$(date)

# Hostname
HOSTNAME=$(hostname)

# RAM Information
TOTAL_RAM=$(free -m | awk '/Mem:/ {print $2}')
USED_RAM=$(free -m | awk '/Mem:/ {print $3}')
FREE_RAM=$(free -m | awk '/Mem:/ {print $4}')

# Calculate RAM Usage %
RAM_USAGE=$(( USED_RAM * 100 / TOTAL_RAM ))

# Status Evaluation
if [ "$RAM_USAGE" -lt 50 ]; then
    STATUS="NORMAL"
    COLOR=$GREEN

elif [ "$RAM_USAGE" -lt "$RAM_THRESHOLD" ]; then
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
echo "RAM Total   : ${TOTAL_RAM} MB"
echo "RAM Used    : ${USED_RAM} MB"
echo "RAM Free    : ${FREE_RAM} MB"
echo "RAM Usage   : ${RAM_USAGE}%"
echo "Threshold   : ${RAM_THRESHOLD}%"

echo -e "Status      : ${COLOR}${STATUS}${NC}"

# Alert Section
if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then

    echo -e "${RED}ALERT: RAM threshold exceeded!${NC}"

    "$(dirname "$0")"/mail_alert.sh \
    "Core Insight RAM Alert" \
    "RAM usage reached ${RAM_USAGE}% on ${HOSTNAME} at ${CURRENT_TIME}. Threshold is ${RAM_THRESHOLD}%."

fi

echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] RAM=${RAM_USAGE}% | Status=${STATUS} | Host=${HOSTNAME} | OS=${OS}" >> ../logs/monitor.log