#!/usr/bin/env bash
# Toggle mirroring of every external monitor (usb-c / HDMI) onto the laptop screen.
# Runtime only: `hyprctl reload` restores monitor.lua.

MAIN="eDP-1"

# "NAME MIRROR_OF" for every connected output except the laptop screen
monitors=$(hyprctl monitors all | awk -v main="$MAIN" '
    /^Monitor / { name = $2 }
    /mirrorOf:/ { if (name != main) print name, $2 }
')

if [ -z "$monitors" ]; then
    hyprctl notify 1 3000 0 "No external monitor"
    exit 0
fi

# Mirror everything unless something is already mirrored
mirror=1
while read -r _ of; do
    [ "$of" != "none" ] && mirror=0
done <<< "$monitors"

while read -r name _; do
    case "$name" in
        HDMI-*) position="auto-up" ;;
        *)      position="auto-right" ;; # usb-c (DP-*)
    esac

    if [ "$mirror" = 1 ]; then
        hyprctl eval "hl.monitor({ output = \"$name\", mode = \"preferred\", position = \"$position\", scale = \"1\", mirror = \"$MAIN\" })"
    else
        hyprctl eval "hl.monitor({ output = \"$name\", mode = \"preferred\", position = \"$position\", scale = \"1\", mirror = \"none\" })"
    fi
done <<< "$monitors"
