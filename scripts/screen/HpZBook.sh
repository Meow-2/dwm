#!/usr/bin/env bash

xrandr --output eDP-1 --mode 2880x1800 --pos 3840x2160 --rotate normal \
    --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --scale 2x2 --rotate normal \
    --output DP-1 --off \
    --output DP-2 --off \
    --output DP-3 --off \
    --output DP-4 --off

"$HOME/.config/dwm/scripts/screen/Wallparper.sh"
