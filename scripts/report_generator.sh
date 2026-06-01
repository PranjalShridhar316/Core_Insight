#!/bin/bash

# ==========================================
# Core Insight - Report Generator
# ==========================================

CURRENT_TIME=$(date)
HOSTNAME=$(hostname)

REPORT_DIR="../reports"

mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/report_$(date +%Y-%m-%d_%H-%M-%S).txt"

# -------------------------
# CPU
# -------------------------

CPU_USAGE=$(top -bn1 | grep "Cpu" | awk '{print int($2+$4)}')

if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE="N/A"
fi

# -------------------------
# RAM
# -------------------------

TOTAL_RAM=$(free -m | awk '/Mem:/ {print $2}')
USED_RAM=$(free -m | awk '/Mem:/ {print $3}')

RAM_USAGE=$(( USED_RAM * 100 / TOTAL_RAM ))

# -------------------------
# DISK
# -------------------------

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# -------------------------
# NETWORK
# -------------------------

PING_OUTPUT=$(ping -c 2 8.8.8.8 2>/dev/null)

if [ $? -eq 0 ]; then

    NETWORK_STATUS="CONNECTED"

    AVG_LATENCY=$(echo "$PING_OUTPUT" | grep "rtt" | awk -F'/' '{print $5}')

else

    NETWORK_STATUS="DISCONNECTED"
    AVG_LATENCY="N/A"

fi

# -------------------------
# UPTIME
# -------------------------

UPTIME_INFO=$(uptime -p)

# -------------------------
# REPORT
# -------------------------

cat > "$REPORT_FILE" << EOF
=========================================
CORE INSIGHT DAILY HEALTH REPORT
=========================================

Generated On:
$CURRENT_TIME

Hostname:
$HOSTNAME

-----------------------------------------
CPU
-----------------------------------------
Usage: $CPU_USAGE%

-----------------------------------------
RAM
-----------------------------------------
Usage: $RAM_USAGE%

-----------------------------------------
DISK
-----------------------------------------
Usage: $DISK_USAGE%

-----------------------------------------
NETWORK
-----------------------------------------
Status : $NETWORK_STATUS
Latency: $AVG_LATENCY ms

-----------------------------------------
UPTIME
-----------------------------------------
$UPTIME_INFO

=========================================
END OF REPORT
=========================================
EOF

echo "Report Generated Successfully"
echo "Location: $REPORT_FILE"