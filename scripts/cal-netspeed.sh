#! /bin/sh

wifi_interface="wlp4s0"
eth_interfaces="eno1"

speed=$(numfmt --to=iec 0)
rx1=$(numfmt --to=iec 0)
rx2=$(numfmt --to=iec 0)
if [ "$(cat /sys/class/net/$eth_interfaces/operstate)" = "up" ]; then
    rx1=$(cat /sys/class/net/$eth_interfaces/statistics/rx_bytes)
    sleep 1
    rx2=$(cat /sys/class/net/$eth_interfaces/statistics/rx_bytes)
elif [ "$(cat /sys/class/net/$wifi_interface/operstate)" = "up" ]; then
    rx1=$(cat /sys/class/net/$wifi_interface/statistics/rx_bytes)
    sleep 1
    rx2=$(cat /sys/class/net/$wifi_interface/statistics/rx_bytes)
else
    sleep 1
fi
speed=$(numfmt --to=iec $(($rx2 - $rx1)))

# net_speed=$speed
~/Programs/dwm/scripts/set-profile.sh net_speed $speed
