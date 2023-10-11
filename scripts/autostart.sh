#!/bin/sh
# DWM自启动脚本

source ~/.profile
video_wallpaper="xwinwrap -fs -nf -ov -- \
mpv -wid WID --loop --no-osc --no-osd-bar \
--input-vo-keyboard=no --really-quiet \
--stop-screensaver=no --panscan=1.0 ~/Pictures/wallpapers/video/1.mp4 \
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
    # 锁屏并关闭屏幕
    xset s 300 300 &
    xset dpms 300 300 300 &
    xss-lock -- betterlockscreen -l dim &

    # 锁屏但不关闭屏幕
    # ~/Programs/dwm/scripts/lock_with_screen_on.sh &
    if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
        ~/Programs/dwm/scripts/set-profile.sh backlight $(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//') &
        # 转发到服务器
        # autossh -M 4396 -NR 43970:localhost:43968 zk@119.29.90.39 -p 43968 &
        # 转发到宿舍
        source ~/.config/zsh/env.zsh
        autossh -M 4396 -NR 43970:localhost:43968 zk@${HOME_IP} -p 43968 &
    fi
}

daemons() {
    [ $1 ] && sleep $1
    # picom --experimental-backends >>/dev/null 2>&1 &
    redshift &
    dunst -conf ~/.config/dunst.conf &
    blueman-applet &
    nm-applet &
    utools &
    # sleep 1
    # bluemail &
    sleep 6
    # safeeyes &
    if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
        todesk &
    fi
    parcellite &
    fcitx5 &
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
