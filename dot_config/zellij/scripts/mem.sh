#!/bin/bash
if [ "$(uname)" = "Darwin" ]; then
    # Match Activity Monitor: Used = (active - purgeable) + wired + compressed
    total_bytes=$(sysctl -n hw.memsize)
    page_size=$(sysctl -n hw.pagesize)
    eval "$(vm_stat | awk '
        /Pages active/                 { print "active=" int($3) }
        /Pages wired/                  { print "wired=" int($4) }
        /Pages purgeable/              { print "purgeable=" int($3) }
        /Pages occupied by compressor/ { print "compressed=" int($NF) }
    ')"
    used=$(( (active - purgeable + wired + compressed) * page_size ))
    total_gb=$(awk "BEGIN{printf \"%.0f\", $total_bytes/1073741824}")
    used_gb=$(awk "BEGIN{printf \"%.1f\", $used/1073741824}")
    printf "%s/%sG" "$used_gb" "$total_gb"
else
    awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%.1f/%.0fG", (t-a)/1048576, t/1048576}' /proc/meminfo
fi
