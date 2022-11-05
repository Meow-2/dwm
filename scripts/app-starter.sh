#!/bin/sh
# 命令调用脚本

terminal() {
    case $1 in
        new)
            alacritty -e ~/Programs/dwm/scripts/set-tmux.sh
            ;;
        temp) alacritty -t temp ;;
        ssh) alacritty -t ssh -e ~/Programs/dwm/scripts/set-lemonade.sh ;;
        btop) alacritty -t temp -e btop ;;
    esac
}

set_vol() {

    case $1 in
        up) /usr/bin/amixer -D pulse -qM set Master 3%+ umute \
            && mpv --no-video ~/Programs/dwm/scripts/resources/audio-volume-change.oga ;;
        down) /usr/bin/amixer -D pulse -qM set Master 3%- umute \
            && mpv --no-video ~/Programs/dwm/scripts/resources/audio-volume-change.oga ;;
        toggle) amixer -D pulse set Master 1+ toggle ;;
    esac
    ~/Programs/dwm/scripts/dwm-status.sh
}

set_backlight() {
    case $1 in
        up) /usr/bin/xbacklight +5 ;;
        down) /usr/bin/xbacklight -5 ;;
    esac
    ~/Programs/dwm/scripts/dwm-status.sh
}

case $1 in
    terminal) terminal $2 ;;
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    filemanager) pcmanfm ;;
    blurlock) betterlockscreen --lock dim ;;
    browser) microsoft-edge-stable --password-store=gnome ;;
    wechat) /opt/apps/com.qq.weixin.deepin/files/run.sh ;;
    qq) /opt/apps/com.qq.tim.spark/files/run.sh ;;
    # qq) icalingua ;;
    flameshot) flameshot gui ;;
    Telegram) telegram-desktop ;;
    wemeet) wemeet ;;
    steam) steam ;;
    obsidian) obsidian ;;
    changewallpaper)
        killall mpv >>/dev/null 2>&1
        killall xwinwrap >>/dev/null 2>&1
        ~/Programs/dwm/scripts/set-profile.sh WALLPAPER_MODE "PIC"
        feh --randomize --bg-fill ~/Pictures/wallpapers/*.jpg
        ;;
    changevideo)
        killall mpv >>/dev/null 2>&1
        killall xwinwrap >>/dev/null 2>&1
        sleep 0.2
        ~/Programs/dwm/scripts/set-profile.sh WALLPAPER_MODE "VIDEO"
        mp4="~/Pictures/wallpapers/video/"$(ls ~/Pictures/wallpapers/video/ | sort -R | head -n1)
        eval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --no-stop-screensaver --panscan=1.0 $mp4 >>/dev/null 2>&1 &
        echo -e "#!/bin/sh\neval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --no-stop-screensaver --panscan=1.0 $mp4 >>/dev/null 2>&1 &" >~/.xwinwrap &
        ;;
    set_vol) set_vol $2 ;;
    set_backlight) set_backlight $2 ;;
esac
