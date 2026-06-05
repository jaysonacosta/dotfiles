#!/usr/bin/env bash
# Battery item: level icon + percentage.
# Shows the estimated time remaining while charging or discharging.

BATT="$(pmset -g batt)"
PERCENT="$(grep -Eo '[0-9]+%' <<<"$BATT" | head -n1 | tr -d '%')"

# No battery (desktop) or read failure: hide the item.
if [[ -z "$PERCENT" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi
PERCENT=$((10#$PERCENT)) # force base-10, avoid octal on a leading zero

# Charge state.
PLUGGED=false
[[ "$BATT" == *"AC Power"* ]] && PLUGGED=true
CHARGED=false
[[ "$BATT" == *"; charged"* ]] && CHARGED=true

# Estimated time remaining (H:MM); blank when full or unknown.
TIME="$(grep -Eo '[0-9]+:[0-9]{2}' <<<"$BATT" | head -n1)"
[[ "$TIME" == "0:00" ]] && TIME=""

# Icon by level; charging bolt while plugged in.
if $PLUGGED; then
  ICON="􀢋"
elif ((PERCENT >= 76)); then
  ICON="􀛨"
elif ((PERCENT >= 51)); then
  ICON="􀺸"
elif ((PERCENT >= 26)); then
  ICON="􀺶"
elif ((PERCENT >= 11)); then
  ICON="􀛩"
else
  ICON="􀛪"
fi

# Label: percentage, plus time estimate when not full.
LABEL="${PERCENT}%"
if [[ -n "$TIME" ]] && ! $CHARGED; then
  LABEL="${PERCENT}% ${TIME}"
fi

sketchybar --set "$NAME" \
  drawing=on \
  icon="$ICON" \
  label="$LABEL"
