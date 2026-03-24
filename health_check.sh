#!/bin/bash

# --- CONFIGURATION ---
THRESHOLD=80
LOG_FILE="/tmp/system_health.log"
HP_IP="192.168.1.155"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# FUNCTION: Send notification to HP
notify_hp() {
    local message="$1"
    ssh -o ConnectTimeout=5 karunix@$HP_IP "echo '[$TIMESTAMP] DELL REPORT: $message' >> /home/karunix/automation-lab/alerts.log"
}

# --- THE CHECKS ---
# 1. Check Disk Usage
CURRENT_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

if [ "$CURRENT_USAGE" -gt "$THRESHOLD" ]; then
    # Auto-heal: clear docker cache if disk is high
    docker system prune -f > /dev/null
    notify_hp "Disk was high (${CURRENT_USAGE}%). Cleanup performed."
else
    notify_hp "Disk OK (${CURRENT_USAGE}%)."
fi

# 2. Check Docker Service
if systemctl is-active --quiet docker; then
    notify_hp "Docker Service: RUNNING."
else
    sudo systemctl restart docker
    notify_hp "Docker Service: WAS DOWN. Attempted restart."
fi
