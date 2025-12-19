#!/bin/bash

SSID="$(ipconfig getsummary en0 | grep -Eo "^\s*SSID\s*:(\s.+)$" | cut -f2 -d ":" | xargs)"

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="􀤆" label="${SSID}"
F