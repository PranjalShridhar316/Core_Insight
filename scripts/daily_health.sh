#!/bin/bash

# ==========================================

# Core Insight - Daily Health Automation

# ==========================================

SCRIPT_DIR="$(dirname "$0")"

# Generate latest report

"$SCRIPT_DIR/report_generator.sh"

# Find newest report

LATEST_REPORT=$(ls -t "$SCRIPT_DIR"/../reports/*.txt 2>/dev/null | head -1)

# Verify report exists

if [ -z "$LATEST_REPORT" ]; then
echo "ERROR: No report found."
exit 1
fi

# Read report contents

REPORT_CONTENT=$(cat "$LATEST_REPORT")

# Send report via existing mail_alert.sh

"$SCRIPT_DIR/mail_alert.sh" "Core Insight Daily Health Report" "$REPORT_CONTENT"

echo "================================"
echo "Daily report sent successfully."
echo "Report: $LATEST_REPORT"
echo "================================"
