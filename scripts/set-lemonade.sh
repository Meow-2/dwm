#!/bin/sh

lemonade server -allow 127.0.0.1 --log-level=4 &
ssh -R 2489:127.0.0.1:2489 -p 43968 zk@119.29.90.39
