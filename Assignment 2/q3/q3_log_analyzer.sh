#!/bin/bash

if [ -z "$1" ]; then
    echo "[!] Please provide a log file as argument."
    echo "    Usage: ./q3_log_analyzer.sh access.log"
    exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "[!] File '$LOG_FILE' not found. Please check the name."
    exit 1
fi

if [ ! -s "$LOG_FILE" ]; then
    echo "[!] Log file is empty. Nothing to analyze."
    exit 1
fi

echo ""
echo "==================================="
echo "       LOG FILE ANALYSIS           "
echo "==================================="
echo "Log File: $LOG_FILE"
echo ""

total=$(wc -l < "$LOG_FILE")
echo "Total Entries: $total"
echo ""

echo "Unique IP Addresses:"
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq)
unique_count=$(echo "$unique_ips" | wc -l)
echo "  Count: $unique_count"

echo "$unique_ips" | while read ip; do
    echo "   - $ip"
done

echo ""


echo "Status Code Summary:"
awk '{print $NF}' "$LOG_FILE" | sort | uniq -c | while read count code; do
    echo "   $code: $count requests"
done

echo ""

echo "Most Frequently Accessed Page:"
most_visited=$(awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -1)
echo "   $most_visited"

echo ""

echo "Top 3 IP Addresses by Requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -3 | \
while read count ip; do
    echo "   $ip - $count requests"
done

echo ""


echo "=== SECURITY ALERTS ==="
echo "IPs with multiple 403 (Forbidden) requests:"
found_threat=false
grep " 403" "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -rn | \
while read count ip; do
    if [ "$count" -gt 1 ]; then
        echo "   [!!] $ip has $count blocked requests - possible threat!"
        found_threat=true
    fi
done

if ! grep -q " 403" "$LOG_FILE"; then
    echo "   No 403 threats detected."
fi

echo ""

CSV_FILE="log_report.csv"
echo "IP,Status,Page,Timestamp" > "$CSV_FILE"
awk '{print $1","$NF","$7","$4}' "$LOG_FILE" | sed 's/\[//' >> "$CSV_FILE"
echo "CSV report saved as: $CSV_FILE"
echo "==================================="
echo ""
