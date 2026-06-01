#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURRENT_TIME=$(date)
HOSTNAME=$(hostname)

echo "================================"
echo "[AUTO RESTART CHECK]"
echo "================================"

SERVICES=("ssh" "cron")

for SERVICE in "${SERVICES[@]}"
do
    STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

    if [ "$STATUS" = "active" ]; then

        echo -e "$SERVICE : ${GREEN}RUNNING${NC}"

    else

        echo -e "$SERVICE : ${YELLOW}STOPPED${NC}"
        echo "Attempting restart..."

        sudo systemctl restart "$SERVICE"

        sleep 2

        NEW_STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

        if [ "$NEW_STATUS" = "active" ]; then

            echo -e "$SERVICE : ${GREEN}RESTARTED SUCCESSFULLY${NC}"

            echo "[$CURRENT_TIME] SERVICE=$SERVICE | ACTION=RESTART_SUCCESS" >> "$SCRIPT_DIR/../logs/monitor.log"

            "$SCRIPT_DIR/mail_alert.sh" \
                "Core Insight Service Recovery" \
                "Service '$SERVICE' was automatically restarted on $HOSTNAME."

        else

            echo -e "$SERVICE : ${RED}RESTART FAILED${NC}"

            echo "[$CURRENT_TIME] SERVICE=$SERVICE | ACTION=RESTART_FAILED" >> "$SCRIPT_DIR/../logs/monitor.log"

            "$SCRIPT_DIR/mail_alert.sh" \
                "Core Insight Critical Service Failure" \
                "Service '$SERVICE' could not be restarted on $HOSTNAME."

        fi
    fi
done

echo "================================"