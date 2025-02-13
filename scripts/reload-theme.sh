#!/bin/bash

# Regenerate colors
wal -i ~/.config/hypr/wallpapers/default.jpg -n --backend haishoku || \
wal -i ~/.config/hypr/wallpapers/default.jpg -n --backend colorthief || \
wal -i ~/.config/hypr/wallpapers/default.jpg -n

# Ensure template links are correct
ln -sf ~/.config/wal/templates/colors-hyprland.conf ~/.cache/wal/colors-hyprland.conf
ln -sf ~/.config/wal/templates/colors-waybar.css ~/.cache/wal/colors-waybar.css

# Kill and restart waybar
killall waybar
waybar &

# Reload Hyprland config
hyprctl reload

# Restart the wallpaper daemon
killall hyprpaper
sleep 1
hyprpaper &