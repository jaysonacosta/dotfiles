#!/bin/bash

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status

if [ "$SENDER" = "packages" ]; then
  VOLUME="$INFO"

  echo "INFO: $INFO" >> /tmp/sketchybar_debug.log

  sketchybar --set "$NAME" icon="􀐚" label="${VOLUME}"
fi

