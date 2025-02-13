#!/bin/bash

# Exit on error and undefined variables
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}This script should not be run as root${NC}"
   exit 1
fi

echo -e "${BLUE}Restoring Hyprland to default state...${NC}"

# Function to safely remove directories
safe_remove() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Backing up $dir to ${dir}.bak.$(date +%Y%m%d_%H%M%S)${NC}"
        mv "$dir" "${dir}.bak.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Packages to remove
PACKAGES=(
    hyprland
    waybar
    xdg-desktop-portal-hyprland
    swaybg
    wlr-randr
    brightnessctl
    dunst
    polkit-kde-agent
    grim
    slurp
    wl-clipboard
    kitty
    alacritty
    thunar
    nwg-look
    swww
    network-manager-applet
    pavucontrol
    python-pywal
    python-pillow
    python-material-you
    python-haishoku
    python-colorthief
    sddm
)

# Ask for confirmation
echo -e "${YELLOW}The following packages will be removed:${NC}"
printf '%s\n' "${PACKAGES[@]}"
read -p "Do you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Operation cancelled.${NC}"
    exit 1
fi

# Remove packages using yay to handle both AUR and regular packages
echo -e "${BLUE}Removing Hyprland and related packages...${NC}"
yay -Rns --noconfirm "${PACKAGES[@]}" || true

echo -e "${BLUE}Removing custom configurations...${NC}"

# Backup and remove config directories
CONFIG_DIRS=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/mako"
    "$HOME/.cache/wal"
)

for dir in "${CONFIG_DIRS[@]}"; do
    safe_remove "$dir"
done

# Disable and stop SDDM
echo -e "${BLUE}Disabling display manager...${NC}"
sudo systemctl disable --now sddm || true

# Clean up SDDM and Wayland configs
sudo rm -f /etc/sddm.conf.d/10-wayland.conf
sudo rm -f /usr/share/wayland-sessions/hyprland.desktop
rm -rf "$HOME/.config/environment.d/wayland.conf"

# Create minimal default Hyprland config
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprland.conf << 'EOL'
# Default minimal Hyprland config
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

# Basic keybindings
$mainMod = SUPER

bind = $mainMod, Return, exec, kitty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun

# Focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
EOL

# Clean up Material You related items
pip uninstall -y materialyou || true

echo -e "${GREEN}Uninstallation complete! Your configurations have been backed up and restored to default.${NC}"
echo -e "${YELLOW}Note: Configuration backups can be found with .bak extension in their original locations.${NC}"
echo -e "${BLUE}You may need to restart your system for all changes to take effect.${NC}"