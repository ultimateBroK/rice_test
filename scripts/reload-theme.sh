#!/bin/bash

# Reload Hyprland colors
hyprctl reload

# Restart Waybar to apply new colors
killall waybar
waybar &

# Notify user
notify-send "Theme Updated" "Material You colors have been reloaded"