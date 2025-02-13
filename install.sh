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

# Check for yay (AUR helper)
if ! command_exists yay; then
    echo -e "${YELLOW}Installing yay AUR helper...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
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
    acpilight
    brightnessctl
    bluez
    bluez-utils
    networkmanager
    python-pywal
    python-pillow
    qt5-wayland
    qt6-wayland
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    kitty
    hyprpaper
    pavucontrol
    imagemagick
)

AUR_PACKAGES=(
    python-material-you
)

# Install main repo packages
echo -e "${BLUE}Installing main repository packages...${NC}"
sudo pacman -Sy --needed --noconfirm "${PACKAGES[@]}"

# Install color extraction backends using pip
echo -e "${BLUE}Installing color extraction backends...${NC}"
pip install --user colorz haishoku colorthief

# Install AUR packages
echo -e "${BLUE}Installing AUR packages...${NC}"
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

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

# Create necessary directories for wallpapers
echo -e "${BLUE}Setting up wallpaper directory...${NC}"
mkdir -p "$HOME/.config/hypr/wallpapers"
chmod 755 "$HOME/.config/hypr/wallpapers"

# Verify ImageMagick installation and permissions
echo -e "${BLUE}Checking ImageMagick installation...${NC}"
if ! command -v magick &> /dev/null; then
    echo -e "${RED}Error: ImageMagick is not installed. Installing...${NC}"
    sudo pacman -S --noconfirm imagemagick
fi

# Create a simple initial wallpaper
echo -e "${BLUE}Creating initial wallpaper...${NC}"
mkdir -p "$HOME/.config/hypr/wallpapers"
if ! magick convert -size 1920x1080 xc:"#1a1b26" "$HOME/.config/hypr/wallpapers/default.jpg"; then
    echo -e "${RED}Failed to create wallpaper. Checking ImageMagick policy...${NC}"
    if [ -f "/etc/ImageMagick-7/policy.xml" ]; then
        sudo sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<policy domain="path" rights="read|write" pattern="@*"/g' "/etc/ImageMagick-7/policy.xml"
    elif [ -f "/etc/ImageMagick-6/policy.xml" ]; then
        sudo sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<policy domain="path" rights="read|write" pattern="@*"/g' "/etc/ImageMagick-6/policy.xml"
    fi
    # Try again after policy update
    magick convert -size 1920x1080 xc:"#1a1b26" "$HOME/.config/hypr/wallpapers/default.jpg"
fi

# Verify wallpaper was created
if [ ! -f "$HOME/.config/hypr/wallpapers/default.jpg" ]; then
    echo -e "${RED}Failed to create wallpaper. Installation cannot continue.${NC}"
    exit 1
fi

# Initialize pywal with the wallpaper
echo -e "${BLUE}Initializing color scheme...${NC}"

# Try different backends in order of preference
if ! wal --backend colorz --saturate 1.0 -i "$HOME/.config/hypr/wallpapers/default.jpg" -n; then
    echo -e "${YELLOW}Colorz backend failed, trying haishoku...${NC}"
    if ! wal --backend haishoku --saturate 1.0 -i "$HOME/.config/hypr/wallpapers/default.jpg" -n; then
        echo -e "${YELLOW}Haishoku backend failed, trying colorthief...${NC}"
        if ! wal --backend colorthief -i "$HOME/.config/hypr/wallpapers/default.jpg" -n; then
            echo -e "${RED}All color extraction backends failed. Using default colors...${NC}"
            # Create a fallback colors file
            mkdir -p "$HOME/.cache/wal"
            cat > "$HOME/.cache/wal/colors" << EOL
#1a1b26
#24283b
#7aa2f7
#bb9af7
#7dcfff
#e0af68
#9ece6a
#a9b1d6
#565f89
#f7768e
#73daca
#ff9e64
#b4f9f8
#c0caf5
#2ac3de
#c0caf5
EOL
        fi
    fi
fi

# Set up pywal templates and links
mkdir -p "${HOME}/.config/wal/templates"
cp -r "$SCRIPT_DIR/config/wal/templates/"* "$HOME/.config/wal/templates/"
ln -sf "$HOME/.config/wal/templates/colors-hyprland.conf" "$HOME/.cache/wal/colors-hyprland.conf"
ln -sf "$HOME/.config/wal/templates/colors-waybar.css" "$HOME/.cache/wal/colors-waybar.css"

# Create pywal post-change script
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

# Make scripts executable
echo -e "${BLUE}Setting up script permissions...${NC}"
chmod +x "$SCRIPT_DIR/scripts/"*.sh

# Ensure ImageMagick policy allows reading/writing the required files
echo -e "${BLUE}Configuring ImageMagick policy...${NC}"
if [ -f "/etc/ImageMagick-7/policy.xml" ]; then
    sudo cp "/etc/ImageMagick-7/policy.xml" "/etc/ImageMagick-7/policy.xml.backup"
    sudo sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<policy domain="path" rights="read|write" pattern="@*"/g' "/etc/ImageMagick-7/policy.xml"
elif [ -f "/etc/ImageMagick-6/policy.xml" ]; then
    sudo cp "/etc/ImageMagick-6/policy.xml" "/etc/ImageMagick-6/policy.xml.backup"
    sudo sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<policy domain="path" rights="read|write" pattern="@*"/g' "/etc/ImageMagick-6/policy.xml"
fi

# Generate initial wallpaper and theme
echo -e "${BLUE}Generating initial wallpaper...${NC}"
bash "$SCRIPT_DIR/scripts/generate-wallpaper.sh" --width 1920 --height 1080

echo -e "${GREEN}Installation complete! Please log out and select Hyprland from your display manager.${NC}"
echo -e "${YELLOW}Note: You may need to restart your system for all changes to take effect.${NC}"