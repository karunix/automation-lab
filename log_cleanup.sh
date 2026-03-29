#!/bin/bash
# Path to your lab logs
LOG_FILE="/home/karunix/automation-lab/alerts.log"

# If the file exists, clear it (truncate) to save space
if [ -f "$LOG_FILE" ]; then
    > "$LOG_FILE"
    echo "Log cleared at $(date)"
fi
