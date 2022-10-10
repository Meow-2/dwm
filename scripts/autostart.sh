#!/bin/sh
# DWM自启动脚本
source ~/.profile

settings() {
    [ $1 ] && sleep $1
    [ $WALLPAPER_MODE != "VIDEO" ] && (~/.fehbg &) || (~/.xwinwrap &)
    xset r rate 180 30 &
    setxkbmap -option caps:swapescape &
    ~/Programs/dwm/scripts/set-touchpad.sh &
    xset s 300 300 &
    xset dpms 300 300 300 &
    xss-lock -- betterlockscreen -l dim
}

daemons() {
    [ $1 ] && sleep $1
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
        ~/Programs/dwm/scripts/cal-netspeed.sh
        ~/Programs/dwm/scripts/dwm-status.sh &
        sleep 1
    done
}

settings &
daemons 1 &
every1s 1 &
