#!/bin/bash

# Configuration
LOG_FILE="/var/log/system_health.log"
EMAIL="example_eail@gmail.com"
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Function to log and email alerts
log_and_alert() {
    local message="$1"
    echo "$message" >> "$LOG_FILE"
    echo -e "Subject: System Health Alert\n\n$message" | ssmtp "$EMAIL"
}
date >> "$LOG_FILE"
# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log_and_alert "High CPU usage: $CPU_USAGE%"
else
    echo "CPU usage: $CPU_USAGE%" >> "$LOG_FILE"
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    log_and_alert "High memory usage: $MEMORY_USAGE%"
else
    echo "Memory usage: $MEMORY_USAGE%" >> "$LOG_FILE"
fi

# Check disk space
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_and_alert "Low disk space: $DISK_USAGE%"
else
    echo "Disk space usage: $DISK_USAGE%" >> "$LOG_FILE"
fi

# Log top 5 memory-consuming processes
echo "Top 5 memory-consuming processes:" >> "$LOG_FILE"
ps aux --sort=-%mem | head -n 6 >> "$LOG_FILE"
echo "---------------------------------" >> "$LOG_FILE"
