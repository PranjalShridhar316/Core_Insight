#!/bin/bash

# ==========================================
# Core Insight - Service Monitoring Module
# ==========================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "[SERVICE CHECK]"
echo "================================"

CURRENT_TIME=$(date)

# Services to Monitor
SERVICES=("ssh" "cron")

for SERVICE in "${SERVICES[@]}"
do
    STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

    if [ "$STATUS" = "active" ]; then

        echo -e "$SERVICE : ${GREEN}RUNNING${NC}"

        echo "[$CURRENT_TIME] $SERVICE RUNNING" \
        >> ../logs/monitor.log

    elif [ "$STATUS" = "inactive" ]; then

        echo -e "$SERVICE : ${YELLOW}STOPPED${NC}"

        echo "[$CURRENT_TIME] $SERVICE STOPPED" \
        >> ../logs/monitor.log

    elif [ "$STATUS" = "failed" ]; then

        echo -e "$SERVICE : ${RED}FAILED${NC}"

        echo "[$CURRENT_TIME] $SERVICE FAILED" \
        >> ../logs/monitor.log

    else

        echo -e "$SERVICE : ${RED}NOT FOUND${NC}"

        echo "[$CURRENT_TIME] $SERVICE NOT FOUND" \
        >> ../logs/monitor.log

    fi
done

echo "================================"