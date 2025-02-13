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

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup config
backup_config() {
    local dir="$1"
    if [ -d "$CONFIG_DIR/$dir" ]; then
        echo -e "${YELLOW}Backing up existing $dir configuration${NC}"
        mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/$dir.bak.$(date +%Y%m%d_%H%M%S)"
    fi
}

echo -e "${BLUE}Setting up Hyprland configuration...${NC}"

# Check for required package managers
if ! command_exists pacman; then
    echo -e "${RED}Error: This script requires pacman package manager${NC}"
    exit 1
fi

if ! command_exists pip; then
    echo -e "${YELLOW}Installing python-pip...${NC}"
    sudo pacman -S --needed python-pip
fi

# Create configuration directories
CONFIG_DIR="$HOME/.config"
RICE_CONFIG=(
    "hypr"
    "waybar"
    "touchpad"
    "monitors"
    "themes"
)

# Create directories
for dir in "${RICE_CONFIG[@]}"; do
    mkdir -p "$CONFIG_DIR/$dir"
    echo -e "${GREEN}Created directory: $CONFIG_DIR/$dir${NC}"
done

# Install required packages
echo -e "${BLUE}Installing required packages...${NC}"
PACKAGES=(
    hyprland
    waybar
    wofi
    wlogout
    wl-clipboard
    mako
    grim
    slurp
    swayidle
    swaylock
    pamixer
    light
    brightnessctl
    bluez
    bluez-utils
    networkmanager
    python-pywal
    qt5-wayland
    qt6-wayland
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    kitty
    hyprpaper
    pavucontrol
    imagemagick
)

# Install packages in parallel using parallel downloads
sudo pacman -Sy --needed --noconfirm "${PACKAGES[@]}"

# Backup existing configs
for dir in "${RICE_CONFIG[@]}"; do
    backup_config "$dir"
done

# Copy configuration files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for dir in "${RICE_CONFIG[@]}"; do
    if [ -d "$SCRIPT_DIR/config/$dir" ]; then
        cp -r "$SCRIPT_DIR/config/$dir" "$CONFIG_DIR/"
        echo -e "${GREEN}Installed $dir configuration${NC}"
    fi
done

# Set up pywal and Material You theming
echo -e "${BLUE}Setting up pywal for Material You theming...${NC}"
mkdir -p "$HOME/.cache/wal"
touch "$HOME/.cache/wal/colors"

# Install Material You color extraction tool if not exists
if ! pip show materialyou >/dev/null 2>&1; then
    pip install --user materialyou
fi

# Set up pywal templates and links
mkdir -p "${HOME}/.config/wal/templates"
ln -sf "$CONFIG_DIR/wal/templates/colors-hyprland.conf" "$HOME/.cache/wal/colors-hyprland.conf"
ln -sf "$CONFIG_DIR/wal/templates/colors-waybar.css" "$HOME/.cache/wal/colors-waybar.css"

# Create pywal post-change script
mkdir -p "${HOME}/.config/wal"
cat > "${HOME}/.config/wal/postrun" << 'EOL'
#!/bin/bash
~/.config/rice_test/scripts/reload-theme.sh
EOL
chmod +x "${HOME}/.config/wal/postrun"

# Enable services
echo -e "${BLUE}Enabling system services...${NC}"
systemctl --user enable --now wireplumber.service pipewire.service pipewire-pulse.service
sudo systemctl enable --now NetworkManager bluetooth

# Set permissions
sudo usermod -aG video,input "$USER"

# Generate initial wallpaper and theme
bash "$SCRIPT_DIR/scripts/generate-wallpaper.sh"

echo -e "${GREEN}Installation complete! Please log out and select Hyprland from your display manager.${NC}"
echo -e "${YELLOW}Note: You may need to restart your system for all changes to take effect.${NC}"