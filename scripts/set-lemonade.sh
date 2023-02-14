#!/bin/sh

if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
    lemonade server -allow 127.0.0.1 --log-level=4 &
    ssh -L 43969:127.0.0.1:43969 -R 2489:127.0.0.1:2489 -p 43968 zk@10.133.83.36
else
    lemonade server -allow 127.0.0.1 --log-level=4 &
    ssh -R 2489:127.0.0.1:2489 -p 43968 zk@119.29.90.39
fi
