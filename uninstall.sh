#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Restoring Hyprland to default state...${NC}"

# Kiểm tra xem đã chạy với quyền root chưa
if [[ $EUID -ne 0 ]]; then
   echo "Script này cần chạy với quyền root (sudo)."
   exit 1
fi

# Make script exit on error
set -e

# Gỡ cài đặt các gói
echo "Gỡ cài đặt Hyprland và các gói liên quan..."
pacman -Rns --noconfirm hyprland waybar xdg-desktop-portal-hyprland \
  swaybg wlr-randr brightnessctl dunst polkit-kde-agent \
  grim slurp wl-clipboard kitty alacritty thunar nwg-look \
  swww network-manager-applet pavucontrol

echo "Removing custom configurations..."

# Remove config files
rm -rf ~/.config/hypr
rm -rf ~/.config/waybar
rm -rf ~/.config/mako

# Reset to default Hyprland config
cat > ~/.config/hypr/hyprland.conf << EOL
monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee)
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

misc {
    disable_hyprland_logo = true
}

decoration {
    rounding = 10
}

animations {
    enabled = true
}

dwindle {
    pseudotile = true
    preserve_split = true
}

$mainMod = SUPER

bind = $mainMod, Return, exec, kitty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun

bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
EOL

echo "Restoration to default Hyprland configuration complete!"

# Remove pywal cache
rm -rf "$HOME/.cache/wal"

echo -e "${GREEN}Uninstallation complete! Your configurations have been restored to default.${NC}"
echo -e "${BLUE}Note: Packages installed by the install script have not been removed.${NC}"
echo -e "${BLUE}If you want to remove them, please use your package manager manually.${NC}"