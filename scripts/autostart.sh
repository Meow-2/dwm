#!/bin/bash

lockfile=/tmp/autostart.lock

# 检查锁文件是否存在
if [ -e "$lockfile" ]; then
    echo "Script is already running."
    exit 1
else
    # 创建锁文件
    touch "$lockfile"

    # 定义一个清理函数来删除锁文件
    cleanup() {
        rm -f "$lockfile"
    }

    # 在脚本退出时调用清理函数
    trap cleanup EXIT

    # 在这里放置你的脚本内容
    # sh -c 'xrandr --output HDMI-1 --mode 1920x1080 --rate 60.00 --scale 1.5x1.5 --output eDP-1 --mode 2880x1800 --rate 90.01 --scale 1.0x1.0 --primary --right-of HDMI-1' &
    source ~/.profile
    video_wallpaper="xwinwrap -fs -nf -ov -- \
    mpv -wid WID --loop --no-osc --no-osd-bar \
    --input-vo-keyboard=no --really-quiet \
    --stop-screensaver=no --panscan=1.0 ~/Pictures/wallpapers/video/1.mp4 \
    >>/dev/null 2>&1 &"

    picom & # for picom-ftlabs-git
    if [ "$WALLPAPER_MODE" != "VIDEO" ]; then
        [ -x ~/.fehbg ] && (~/.fehbg &) || (feh --bg-scale ~/Pictures/wallpapers/color.jpg &)
    else
        [ -f ~/.xwinwrap ] && (sh ~/.xwinwrap &) || (eval $video_wallpaper)
    fi
    if [ ! -f ~/.cache/betterlockscreen/current/lock_blur.png ]; then
        betterlockscreen -u ~/Pictures/wallpapers/lock.jpg &
    fi

    # 屏保时间，本来想全用/etc/X11/xorg.conf.d/10-serverflags.conf设置的
    # 但是这个文件居然没有cycletime的设置方法，太离谱了，详见https://bbs.archlinux.org/viewtopic.php?id=282146
    # 还是不设置xset s 360 360了，会覆盖xorg keyboard，要设置也应该一起设置xset r rate 210 40
    xset s 360 360 r rate 210 40 &
    xss-lock -- "playerctl play-pause;betterlockscreen -l dim &" &

    # settings() {
    #     [ $1 ] && sleep $1
    #     # picom --experimental-backends >>/dev/null 2>&1 &  # for picom-yaocccc-git
    #     # eval "xbacklight = 5" &
    #     ~/.config/dwm/scripts/set-touchpad.sh &
    #     xset r rate 210 40 &
    #     # 直接编辑/etc/X11/xorg.conf.d/00-keyboard.conf
    #     # Section "InputClass"
    #     #         Identifier "system-keyboard"
    #     #         MatchIsKeyboard "on"
    #     #         Option "XkbOptions" "caps:swapescape"
    #     #         Option "XkbOptions" "ctrl:ralt_rctrl"
    #     # EndSection
    #     setxkbmap -option "caps:swapescape,ctrl:ralt_rctrl" &
    #
    #     if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
    #         ~/.config/dwm/scripts/set-profile.sh backlight $(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//') &
    #         # 转发到服务器
    #         # autossh -M 4396 -NR 43970:localhost:43968 zk@119.29.90.39 -p 43968 &
    #         # 转发到宿舍
    #         source ~/.config/zsh/env.zsh
    #         autossh -M 4396 -fCNR 43970:localhost:43968 zk@${SSHD_PORT_FORWARDING_IP} -p 43968 &
    #
    #         # # 锁屏但不关闭屏幕
    #         # ~/.config/dwm/scripts/lock_with_screen_on.sh &
    #         # 锁屏并关闭屏幕
    #         xset s 360 360 &
    #         xset dpms 360 360 360 &
    #         xss-lock -- betterlockscreen -l dim &
    #     else
    #         # 锁屏并关闭屏幕
    #         xset s 360 360 &
    #         xset dpms 360 360 360 &
    #         xss-lock -- betterlockscreen -l dim &
    #     fi
    # }

    daemons() {
        [ $1 ] && sleep $1
        # if [ "$(cat /etc/hostname)" = "ThinkBook" ]; then
        #     # snixembed --fork &
        #     # sleep 6
        #     # pkill snixembed &
        # fi
        dwmblocks &
        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
        libinput-gestures-setup autostart start &
        dunst -conf ~/.config/dunst/dwm.conf &
        # snixembed --fork &
        dropbox &
        sleep 1
        redshift &
        # blueberry &
        blueman-applet &
        sleep 1
        nm-applet &
        safeeyes &
        # sleep 6
        fcitx5 &
        sleep 1
        # bluemail &
        # safeeyes &
        if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
            todesk &
        fi
        utools &
        sleep 2
        Snipaste &
        diodon &
        plank &
        # parcellite &
        # ~/scripts/app-starter.sh picom &
    }

    every1s() {
        [ $1 ] && sleep $1
        while true; do
            if [ "$(xdotool search --name 'wemeetapp')" != "" ]; then
                xset s reset
            fi
            ~/.config/dwm/scripts/cal-netspeed.sh
            ~/.config/dwm/scripts/dwm-status.sh &
            sleep 1
        done
    }

    # settings 1 &
    daemons 1 &
    while :; do
        sleep 1
    done
fi
