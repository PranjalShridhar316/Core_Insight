#!/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/monitor.log"

while true
do
clear


cat << "EOF"
   _____                    _____           _       _     _     
  / ____|                  |_   _|         (_)     | |   | |
 | |     ___  _ __ ___       | |  _ __  ___ _  __ _| |__ | |_
 | |    / _ \| '__/ _ \      | | | '_ \/ __| |/ _` | '_ \| __|
 | |___| (_) | | |  __/     _| |_| | | \__ \ | (_| | | | | |_
  \_____\___/|_|  \___|    |_____|_| |_|___/_|\__, |_| |_|\__|
                                                __/ |
                                               |___/
EOF

echo
echo "========================================"
echo "      CORE INSIGHT SYSTEM DASHBOARD"
echo "========================================"
echo

echo "1. CPU Check"
echo "2. RAM Check"
echo "3. Disk Check"
echo "4. Network Check"
echo "5. Process Check"
echo "6. Uptime Check"
echo "7. Generate Report"
echo "8. Send Daily Health Report"
echo "9. View Monitor Logs"
echo "10. Auto Restart Services"
echo "0. Exit"
echo
echo "========================================"

read -p "Select an option: " CHOICE

echo

case $CHOICE in

    1)
        "$SCRIPT_DIR/cpu_check.sh"
        ;;

    2)
        "$SCRIPT_DIR/ram_check.sh"
        ;;

    3)
        "$SCRIPT_DIR/disk_check.sh"
        ;;

    4)
        "$SCRIPT_DIR/network_check.sh"
        ;;

    5)
        "$SCRIPT_DIR/process_check.sh"
        ;;

    6)
        "$SCRIPT_DIR/uptime_check.sh"
        ;;

    7)
        "$SCRIPT_DIR/report_generator.sh"
        ;;

    8)
        "$SCRIPT_DIR/daily_health.sh"
        ;;

    9)
        echo "========================================"
        echo "          MONITOR LOGS"
        echo "========================================"

        if [ -f "$LOG_FILE" ]; then
            tail -30 "$LOG_FILE"
        else
            echo "Log file not found:"
            echo "$LOG_FILE"
        fi
        ;;

    10)
       "$SCRIPT_DIR/auto_restart.sh"
        ;;

    0)
        echo "See You Later......"
        exit 0
        ;;

    *)
        echo "Invalid option."
        ;;
esac

echo
read -p "Press Enter to continue..."

done