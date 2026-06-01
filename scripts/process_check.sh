#!/bin/bash

# ==========================================
# Core Insight - Process Monitoring Module
# ==========================================

# Terminal Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================"
echo "[PROCESS CHECK]"
echo "================================"

# Environment
OS=$(uname -s)

# Hostname
HOSTNAME=$(hostname)

# Timestamp
CURRENT_TIME=$(date)

# Display System Info
echo "Environment : $OS"
echo "Hostname    : $HOSTNAME"
echo "Time        : $CURRENT_TIME"

echo
echo "================================"
echo "TOP 5 CPU CONSUMERS"
echo "================================"

printf "%-8s %-25s %-10s\n" "PID" "PROCESS" "CPU%"

ps -eo pid,comm,%cpu --sort=-%cpu | head -6 | tail -5 | while read PID NAME CPU
do
    printf "%-8s %-25s %-10s\n" "$PID" "$NAME" "$CPU"
done

echo
echo "================================"
echo "TOP 5 RAM CONSUMERS"
echo "================================"

printf "%-8s %-25s %-10s\n" "PID" "PROCESS" "RAM%"

ps -eo pid,comm,%mem --sort=-%mem | head -6 | tail -5 | while read PID NAME MEM
do
    printf "%-8s %-25s %-10s\n" "$PID" "$NAME" "$MEM"
done

echo
echo "================================"

# Logging
mkdir -p ../logs

echo "[$CURRENT_TIME] PROCESS CHECK EXECUTED | HOST=$HOSTNAME" >> ../logs/monitor.logs