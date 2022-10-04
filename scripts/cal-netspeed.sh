#! /bin/sh

wifi_interface="wlp4s0"
eth_interfaces="eno1"

speed=$(numfmt --to=iec 0)
wifi_rx1=$(numfmt --to=iec 0)
wifi_rx2=$(numfmt --to=iec 0)
eth_rx1=$(numfmt --to=iec 0)
eth_rx2=$(numfmt --to=iec 0)
if [ "$(cat /sys/class/net/$wifi_interface/operstate)" = "up" ]; then
    wifi_rx1=$(cat /sys/class/net/$wifi_interface/statistics/rx_bytes)
fi
if [ "$(cat /sys/class/net/$eth_interfaces/operstate)" = "up" ]; then
    eth_rx1=$(cat /sys/class/net/$eth_interfaces/statistics/rx_bytes)
fi
sleep 1
if [ "$(cat /sys/class/net/$wifi_interface/operstate)" = "up" ]; then
    wifi_rx2=$(cat /sys/class/net/$wifi_interface/statistics/rx_bytes)
fi
if [ "$(cat /sys/class/net/$eth_interfaces/operstate)" = "up" ]; then
    eth_rx2=$(cat /sys/class/net/$eth_interfaces/statistics/rx_bytes)
fi
speed=$(numfmt --to=iec $(($eth_rx2 + $wifi_rx2 - $eth_rx1 - $wifi_rx1)))

# net_speed=$speed
~/Programs/dwm/scripts/set-profile.sh net_speed $speed
