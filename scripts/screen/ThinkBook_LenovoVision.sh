#!/bin/sh

xrandr --output eDP --mode 2880x1800 --pos 3840x2160 --rotate normal \
    --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 --scale 2x2 --rotate normal \
    --output DisplayPort-0 --off \
    --output DisplayPort-1 --off \
    --output DisplayPort-2 --off \
    --output DisplayPort-3 --off \
    --output DisplayPort-4 --off \
    --output DisplayPort-5 --off

"$HOME/.config/dwm/scripts/screen/Wallparper.sh"
