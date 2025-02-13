#!/bin/bash

# Kill any existing waybar instances
killall waybar

# Wait a moment
sleep 1

# Start waybar with config from the correct location
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &

# Output status
echo "Waybar restarted"