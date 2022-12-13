#!/bin/sh
# DWM自启动脚本

source ~/.profile
video_wallpaper="xwinwrap -fs -nf -ov -- \
mpv -wid WID --loop --no-osc --no-osd-bar \
--input-vo-keyboard=no --really-quiet \
--no-stop-screensaver --panscan=1.0 ~/Pictures/wallpapers/video/day.webm \
>>/dev/null 2>&1 &"

settings() {
    [ $1 ] && sleep $1
    /usr/bin/xbacklight = 85 &
    if [ "$WALLPAPER_MODE" != "VIDEO" ]; then
        [ -x ~/.fehbg ] && (~/.fehbg &) || (feh --bg-scale ~/Pictures/wallpapers/color.jpg &)
    else
        [ -f ~/.xwinwrap ] && (sh ~/.xwinwrap &) || (eval $video_wallpaper)
    fi
    if [ ! -f ~/.cache/betterlockscreen/current/lock_blur.png ]; then
        betterlockscreen -u ~/Pictures/wallpapers/lock.jpg &
    fi
    ~/Programs/dwm/scripts/set-touchpad.sh &
    xset r rate 210 40 &
    setxkbmap -option caps:swapescape &
    xset s 300 300 &
    xset dpms 300 300 300 &
    xss-lock -- betterlockscreen -l dim
}

daemons() {
    [ $1 ] && sleep $1
    # picom --experimental-backends >>/dev/null 2>&1 &
    redshift &
    dunst -conf ~/.config/dunst.conf &
    blueman-applet &
    nm-applet &
    mailspring -b &
    utools &
    sleep 6
    safeeyes &
    fcitx5 &
    sleep 2
    parcellite &
    # ~/scripts/app-starter.sh picom &
}

every1s() {
    [ $1 ] && sleep $1
    while true; do
        if [ "$(xdotool search --name 'wemeetapp')" != "" ]; then
            xset s reset
        fi
        ~/Programs/dwm/scripts/cal-netspeed.sh
        ~/Programs/dwm/scripts/dwm-status.sh &
        sleep 1
    done
}

settings 1 &
daemons 1 &
every1s 1 &
