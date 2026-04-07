#!/bin/bash
if [ "$(uname)" = "Darwin" ]; then
    top -l 1 -n 0 2>/dev/null | awk '/CPU usage/{printf "%.0f%%", $3}'
else
    # Read two samples 1s apart and compute delta for real-time CPU%
    read -r _ u1 n1 s1 i1 w1 hi1 si1 _ < /proc/stat
    sleep 1
    read -r _ u2 n2 s2 i2 w2 hi2 si2 _ < /proc/stat
    total1=$((u1+n1+s1+i1+w1+hi1+si1))
    total2=$((u2+n2+s2+i2+w2+hi2+si2))
    idle_d=$((i2-i1))
    total_d=$((total2-total1))
    if [ "$total_d" -gt 0 ]; then
        usage=$(( (total_d - idle_d) * 100 / total_d ))
        printf "%d%%" "$usage"
    else
        printf "0%%"
    fi
fi
