#!/usr/bin/env bash

wallpaper_mode=PIC
wallpaper_path="$HOME/.config/dwm/assets/wall.jpg"
# wallpaper_path2="$HOME/.config/dwm/assets/wall.jpg"
# wallpaper_path3="$HOME/.config/dwm/assets/wall.jpg"
lockpaper_path="$HOME/.config/dwm/assets/lock.jpg"
if [ $wallpaper_mode = "PIC" ]; then
    feh --no-fehbg --bg-fill "$wallpaper_path" "$wallpaper_path" "$wallpaper_path" &
elif [ $wallpaper_mode = "VIDEO" ]; then
    xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --stop-screensaver=no --panscan=1.0 "$wallpaper_path" >>/dev/null 2>&1 &
fi

betterlockscreen -u "$lockpaper_path" &
