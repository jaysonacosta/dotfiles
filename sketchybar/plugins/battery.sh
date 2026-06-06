#!/bin/bash

BATTERY_STATUS="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATTERY_STATUS" | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(echo "$BATTERY_STATUS" | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

if [ "$PERCENTAGE" -gt 90 ]; then
	ICON="􀛨"
elif [ "$PERCENTAGE" -gt 60 ]; then
	ICON="􀺸"
elif [ "$PERCENTAGE" -gt 30 ]; then
	ICON="􀺶"
elif [ "$PERCENTAGE" -gt 15 ]; then
	ICON="􀛩"
else
	ICON="􀛪"
fi

if [[ "$CHARGING" != "" ]]; then
	ICON="􀢋"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
