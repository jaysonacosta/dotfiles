#!/bin/bash

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# ~/.config/sketchybar/plugins/clock/clock &
# sketchybar --set "$NAME" icon=􀧞 label="$(date '+%b %d, %I:%M %p')"

killall clock >/dev/null

~/.config/sketchybar/plugins/clock/bin/clock