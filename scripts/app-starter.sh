#!/bin/sh
# 命令调用脚本

# terminal() {
#     case $1 in
#         new) alacritty -e ~/Programs/dwm/scripts/set-tmux.sh ;;
#         temp) alacritty -t temp ;;
#         ssh) alacritty -e ~/Programs/dwm/scripts/set-lemonade.sh ;;
#         btop) alacritty -t temp -e btop ;;
#     esac
# }

# browser_command="google-chrome-stable"
browser_command="microsoft-edge-stable"
browser_flags="--password-store=gnome"
# [ "$(cat /etc/hostname)" = "Noatomusk" ] && browser_flags=$browser_flags" --force-device-scale-factor=1.2"

# terminal_temp_command="wezterm start --class weztemp"
# dwm wezterm浮动窗口的字体会莫名其妙放大，这可能和主机的显示器dpi设置有关
# [ "$(cat /etc/hostname)" = "Noatomusk" ] && terminal_temp_command="wezterm --config font_size=12 start --class weztemp"

terminal() {
    case $1 in
        new) wezterm start ;;
        # temp) $terminal_temp_command ;;
        temp) wezterm start --class weztemp ;;
        current) wezterm start --class wezcurrent ;;
        ssh) wezterm --config-file ~/.config/wezterm/wezterm_tmux.lua start -- ~/Programs/dwm/scripts/set-lemonade.sh ;;
        btop) wezterm start --class weztemp -- btop ;;
    esac
}

set_vol() {
    case $1 in
        up) pulsemixer --change-volume +3 \
            && mpv --no-video ~/Programs/dwm/scripts/resources/audio-volume-change.oga ;;
        down) pulsemixer --change-volume -3 \
            && mpv --no-video ~/Programs/dwm/scripts/resources/audio-volume-change.oga ;;
        toggle) pulsemixer --toggle-mute ;;
    esac
    ~/Programs/dwm/scripts/dwm-status.sh
}

set_backlight() {
    if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
        current_backlight=$(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//')
        case $1 in
            up)
                /usr/bin/ddcutil setvcp 10 $((current_backlight + 20))
                ;;
            down)
                /usr/bin/ddcutil setvcp 10 $((current_backlight - 20))
                ;;
        esac
        ~/Programs/dwm/scripts/set-profile.sh backlight $(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//')
    elif [ "$(cat /etc/hostname)" = "ThinkBook" ]; then
        case $1 in
            up) /usr/bin/light -A 5 ;;
            down) /usr/bin/light -U 5 ;;
        esac
    else
        case $1 in
            up) /usr/bin/xbacklight +5 ;;
            down) /usr/bin/xbacklight -5 ;;
        esac
    fi
    ~/Programs/dwm/scripts/dwm-status.sh
}

case $1 in
    terminal) terminal $2 ;;
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    getinfo)
        winfo=$(xprop | awk '/^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/,"\nclass:"); print}/^WM_NAME/{sub(/.* =/, "title:"); print}')
        echo $winfo | xclip -selection c
        dunstify "$winfo"
        ;;
    filemanager) pcmanfm ;;
    blurlock) betterlockscreen --lock dim ;;
    # browser) microsoft-edge-stable --password-store=gnome ;;
    browser) $browser_command $browser_flags ;;
    wechat) /opt/apps/com.qq.weixin.deepin/files/run.sh ;;
    # qq) /opt/apps/com.qq.tim.spark/files/run.sh ;;
    # qq) icalingua ;;
    qq) linuxqq ;;
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
        eval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --stop-screensaver=no --panscan=1.0 $mp4 >>/dev/null 2>&1 &
        echo -e "#!/bin/sh\neval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --stop-screensaver=no --panscan=1.0 $mp4 >>/dev/null 2>&1 &" >~/.xwinwrap &
        ;;
    set_vol) set_vol $2 ;;
    set_backlight) set_backlight $2 ;;
esac
