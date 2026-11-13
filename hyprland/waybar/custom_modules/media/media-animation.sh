#!/usr/bin/env bash
frames=("▁▃▄▆█" "▃▄▆█▆" "▄▆█▆▄" "▆█▆▄▃" "█▆▄▃▁" "▆▄▃▁▃")
while true; do
    status=$(playerctl status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
        for frame in "${frames[@]}"; do
            echo "$frame"
            sleep 0.25
        done
    elif [[ "$status" == "Paused" ]]; then
        echo ""
        sleep 1
    else
        echo ""
        sleep 2
    fi
done
