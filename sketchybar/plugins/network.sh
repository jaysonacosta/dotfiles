#!/usr/bin/env bash
# Network item: connection-type icon (VPN-aware) + SSID/interface label.
# Clicking the item toggles a popup showing live down/up rates.

CACHE="${TMPDIR:-/tmp}"

# Wi-Fi device, cached (networksetup is slow to call every tick).
wifi_cache="$CACHE/sketchybar_wifi_dev"
if [[ -s "$wifi_cache" ]]; then
  WIFI_DEV="$(<"$wifi_cache")"
else
  WIFI_DEV="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2; exit}')"
  WIFI_DEV="${WIFI_DEV:-en0}"
  printf '%s' "$WIFI_DEV" >"$wifi_cache"
fi

# Active VPN tunnels: one "utunN ip" line per utun iface that has an inet addr.
VPN="$(ifconfig 2>/dev/null | awk '/^[^[:space:]]/{i=""} /^utun[0-9]/{i=$1} /inet /{if(i){print i" "$2; i=""}}')"

# Physical link: prefer wired, fall back to Wi-Fi.
PHYS=""
TYPE="none"
for dev in $(ifconfig -lu 2>/dev/null); do
  [[ "$dev" == "$WIFI_DEV" ]] && continue
  case "$dev" in en* | bridge*) ;; *) continue ;; esac
  if ipconfig getifaddr "$dev" >/dev/null 2>&1; then
    PHYS="$dev"
    TYPE="wired"
    break
  fi
done
if [[ -z "$PHYS" ]] && ipconfig getifaddr "$WIFI_DEV" >/dev/null 2>&1; then
  PHYS="$WIFI_DEV"
  TYPE="wifi"
fi

# Icon: VPN takes precedence, then link type.
if [[ -n "$VPN" ]]; then
  ICON="􁅏"
elif [[ "$TYPE" == "wired" ]]; then
  ICON="􀤆"
elif [[ "$TYPE" == "wifi" ]]; then
  ICON="􀙇"
else
  ICON="􁣡"
fi

# Identity label: SSID on Wi-Fi, interface name when wired, else offline.
if [[ "$TYPE" == "wifi" ]]; then
  LABEL="$(ipconfig getsummary "$WIFI_DEV" 2>/dev/null | awk -F' : ' '/ SSID :/{print $2; exit}')"
  LABEL="${LABEL:-Wi-Fi}"
elif [[ "$TYPE" == "wired" ]]; then
  LABEL="$PHYS"
else
  LABEL="offline"
fi
sketchybar --set "$NAME" icon="$ICON" label="$LABEL"

# Popup rows: down/up rates from this interface's byte-counter delta.
human() { awk -v b="$1" 'BEGIN{split("B K M G T",u," "); i=1; while(b>=1024&&i<5){b/=1024;i++} printf (i==1?"%d%s":"%.1f%s"), b, u[i]}'; }

down="0B"
up="0B"
if [[ -n "$PHYS" ]]; then
  read -r rx tx < <(netstat -ibn -I "$PHYS" 2>/dev/null | awk '$3 ~ /^<Link#/{print $7, $10; exit}')
  if [[ -n "$rx" ]]; then
    now=$(date +%s)
    state="$CACHE/sketchybar_net_${PHYS}"
    if [[ -f "$state" ]]; then
      read -r prx ptx pnow <"$state"
      dt=$((now - pnow))
      ((dt < 1)) && dt=1
      drx=$(((rx - prx) / dt))
      ((drx < 0)) && drx=0
      dtx=$(((tx - ptx) / dt))
      ((dtx < 0)) && dtx=0
      down="$(human "$drx")"
      up="$(human "$dtx")"
    fi
    printf '%s %s %s\n' "$rx" "$tx" "$now" >"$state"
  fi
fi
sketchybar --set "${NAME}.down" label="$down" --set "${NAME}.up" label="$up"
