#!/bin/sh

# Get id of touchpad and the id of the field corresponding to
# natural scrolling
id=$(xinput list | grep -i "Touchpad" | cut -d'=' -f2 | cut -d'[' -f1)
natural_scrolling_id=$(xinput list-props $id | grep -i "Natural Scrolling Enabled (" | cut -d'(' -f2 | cut -d')' -f1)

# Set the property to true
#!/bin/bash

# Get id of touchpad and the id of the field corresponding to
# tapping to click
tap_to_click_id=$(xinput list-props $id | grep -i "tapping enabled (" | cut -d'(' -f2 | cut -d')' -f1)
accel_speed_id=$(xinput list-props $id | grep -i "Accel Speed (" | cut -d'(' -f2 | cut -d')' -f1)
# Set the property to true
xinput --set-prop $id $natural_scrolling_id 1 &
xinput --set-prop $id $tap_to_click_id 1 &
xinput --set-prop $id $accel_speed_id 0.4 &
