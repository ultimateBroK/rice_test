#!/bin/bash

# Make script exit on error
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Setting up Hyprland configuration...${NC}"

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
sudo pacman -S --needed \
    hyprland \
    waybar \
    wofi \
    wlogout \
    wl-clipboard \
    mako \
    grim \
    slurp \
    swayidle \
    swaylock \
    pamixer \
    light \
    brightnessctl \
    bluez \
    bluez-utils \
    networkmanager \
    python-pywal \
    qt5-wayland \
    qt6-wayland \
    xdg-desktop-portal-hyprland \
    polkit-kde-agent \
    kitty \
    hyprpaper \
    pavucontrol \
    imagemagick

# Create backup of existing configs if they exist
for dir in "${RICE_CONFIG[@]}"; do
    if [ -d "$CONFIG_DIR/$dir" ]; then
        mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/$dir.bak"
        echo -e "${BLUE}Backed up existing $dir configuration${NC}"
    fi
done

# Copy configuration files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for dir in "${RICE_CONFIG[@]}"; do
    if [ -d "$SCRIPT_DIR/config/$dir" ]; then
        cp -r "$SCRIPT_DIR/config/$dir" "$CONFIG_DIR/"
        echo -e "${GREEN}Installed $dir configuration${NC}"
    fi
done

# Set up pywal for Material You theming
echo -e "${BLUE}Setting up pywal for Material You theming...${NC}"
mkdir -p "$HOME/.cache/wal"
touch "$HOME/.cache/wal/colors"

# Install Material You color extraction tool
pip install materialyou

# Set up pywal
wal -i ~/.config/hypr/wallpapers/default.jpg

# Generate wallpaper
magick -size 1920x1200 \
    -define gradient:vector='0,0 1920,1200' \
    -define gradient:angle=45 \
    gradient:'#1a1b26-#24283b' \
    -fill '#7aa2f7' \
    -stroke '#7aa2f7' \
    -strokewidth 2 \
    -draw "path 'M 0,0 L 1920,0 L 1920,1200 L 0,1200 Z M 200,200 L 1720,200 L 1720,1000 L 200,1000 Z'" \
    -draw "path 'M 300,300 L 1620,300 L 1620,900 L 300,900 Z'" \
    -blur 0x2 \
    ~/.config/hypr/wallpapers/default.jpg

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# Set permissions for brightness control
sudo usermod -aG video $USER

# Create pywal template directory
mkdir -p "${HOME}/.config/wal/templates"

# Link our custom templates to pywal templates directory
ln -sf ~/.config/wal/templates/colors-hyprland.conf ~/.cache/wal/colors-hyprland.conf
ln -sf ~/.config/wal/templates/colors-waybar.css ~/.cache/wal/colors-waybar.css

# Create pywal post-change script
cat > "${HOME}/.config/wal/postrun" << 'EOL'
#!/bin/bash
~/.config/rice_test/scripts/reload-theme.sh
EOL

chmod +x "${HOME}/.config/wal/postrun"

# Generate initial wallpaper and theme
~/.config/rice_test/scripts/generate-wallpaper.sh

echo -e "${GREEN}Installation complete! Please logout and select Hyprland from your display manager.${NC}"