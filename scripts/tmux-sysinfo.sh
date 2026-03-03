#!/bin/sh
cpu=$(ps -A -o %cpu | awk -F. '{s+=$1} END {printf "%d", s/'"$(sysctl -n hw.logicalcpu)"'}')
ram_free=$(memory_pressure 2>/dev/null | awk '/System-wide memory free percentage:/{print $5+0}')
ram_used=$((100 - ram_free))
total=$(sysctl -n hw.memsize | awk '{printf "%.0fG", $1/1073741824}')
printf '⚡ CPU %s%% · RAM %s%%/%s' "$cpu" "$ram_used" "$total"
