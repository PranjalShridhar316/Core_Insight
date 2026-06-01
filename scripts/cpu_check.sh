#!/bin/bash

# ==========================================
# Core Insight - CPU Monitoring Module
# ==========================================

# Load Configuration
source ../configs/threshold.conf

# Validate Configuration
if [ -z "$CPU_THRESHOLD" ]; then
    echo "ERROR: CPU_THRESHOLD not found in threshold.conf"
    exit 1
fi

# Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "[CPU CHECK]"
echo "================================"

# Environment Detection
OS=$(uname -s)

# Timestamp
CURRENT_TIME=$(date)

# Hostname
HOSTNAME=$(hostname)

# CPU Core Count
if command -v nproc >/dev/null 2>&1; then
    CORES=$(nproc)
else
    CORES="Unknown"
fi

# CPU Usage Collection
CPU_USAGE=$(top -bn1 2>/dev/null | grep "Cpu" | awk '{print int($2+$4)}')

# Fallback if CPU Usage cannot be determined
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE="N/A"
fi

# Status Evaluation
if [[ "$CPU_USAGE" =~ ^[0-9]+$ ]]; then

    if [ "$CPU_USAGE" -lt 50 ]; then
        STATUS="NORMAL"
        COLOR=$GREEN

    elif [ "$CPU_USAGE" -lt "$CPU_THRESHOLD" ]; then
        STATUS="WARNING"
        COLOR=$YELLOW

    else
        STATUS="CRITICAL"
        COLOR=$RED
    fi

else
    STATUS="UNKNOWN"
    COLOR=$YELLOW
fi

# Display Information
echo "Environment : $OS"
echo "Hostname    : $HOSTNAME"
echo "Time        : $CURRENT_TIME"
echo "CPU Cores   : $CORES"

if [[ "$CPU_USAGE" =~ ^[0-9]+$ ]]; then
    echo "CPU Usage   : ${CPU_USAGE}%"
else
    echo "CPU Usage   : N/A"
fi

echo "Threshold   : ${CPU_THRESHOLD}%"
echo -e "Status      : ${COLOR}${STATUS}${NC}"

# Load Average
LOAD_AVG=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}')

if [ -n "$LOAD_AVG" ]; then
    echo "Load Avg    : $LOAD_AVG"
fi

# Alert Section
if [[ "$CPU_USAGE" =~ ^[0-9]+$ ]] && [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then

    echo -e "${RED}ALERT: CPU threshold exceeded!${NC}"

    "$(dirname "$0")"/mail_alert.sh \
    "Core Insight CPU Alert" \
    "CPU usage reached ${CPU_USAGE}% on ${HOSTNAME} at ${CURRENT_TIME}. Threshold is ${CPU_THRESHOLD}%."

fi

echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] CPU=${CPU_USAGE}% | Status=${STATUS} | Cores=${CORES} | Host=${HOSTNAME} | OS=${OS}" >> ../logs/monitor.log