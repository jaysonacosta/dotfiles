#!/bin/bash

SSID="$(ipconfig getsummary en0 | grep -Eo "^\s*SSID\s*:(\s.+)$" | cut -f2 -d ":" | xargs)"

if [[ -z "$SSID" ]]; then
    ICON="􁣡"
    else
    ICON="􀤆"
fi

sketchybar --set "$NAME" icon="${ICON}" label="${SSID:--}"
