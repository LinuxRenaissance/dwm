#!/bin/sh

INTERVAL=5

while true; do
    TIME=$(date "+%d %a %H:%M")

    BAT_LIFE=$(apm -l 2>/dev/null)
    [ -z "$BAT_LIFE" ] && BAT_LIFE="??"
    BAT="  $BAT_LIFE%"

    FREE_MB=$(vmstat | awk 'NR==3 {gsub("M","",$4); print $4}')
    AVAIL_GB=$(awk "BEGIN {printf \"%.1f\", $FREE_MB/1024}")
    RAM="  ${AVAIL_GB}GB"

    # CPU usage (current)
    CPU_IDLE=$(iostat -c 2 2>/dev/null | awk '/^[[:space:]]*[0-9]/ {line=$0} END {if (line!=""){split(line,a); print a[length(a)]}}')
    CPU_IDLE=$(echo "$CPU_IDLE" | tr -dc '0-9')
    [ -z "$CPU_IDLE" ] && CPU_IDLE=0

    CPU_USAGE=$(expr 100 - $CPU_IDLE)
    [ "$CPU_USAGE" -lt 0 ] && CPU_USAGE=0
    [ "$CPU_USAGE" -gt 100 ] && CPU_USAGE=100

    CPU="  ${CPU_USAGE}%"

    CLOCK="  $TIME"

    STATUS=" $BAT | $RAM | $CPU | $CLOCK"

    xsetroot -name "$STATUS"
    sleep $INTERVAL
done

