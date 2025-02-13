# Material You Hyprland Configuration
A modern, Material You-inspired Hyprland configuration with dynamic theming, smooth animations, and an elegant user interface.

## Features
- 🎨 **Dynamic Color Schemes**
  - Automatically generates color schemes from your wallpaper using pywal
  - Multiple color extraction backends (haishoku, colorthief)
  - Seamless integration with Waybar and Hyprland
- 🖼️ **Auto Wallpaper Generation**
  - Material Design inspired patterns
  - Dynamic geometric patterns with accent colors
  - Custom resolution support
- ⚡ **Modern Desktop Experience**
  - Smooth window animations
  - Material Design-inspired transitions
  - Integrated SDDM display manager
  - Workspace sliding animations
- 🛠️ **Pre-configured Components**
  - Waybar with system information
  - Automatic XDG portal setup
  - Polkit authentication agent
  - Network and Bluetooth management

## Requirements
- Arch Linux or compatible distribution
- `git` and `base-devel` for AUR packages
- No root privileges needed (sudo access required)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/rice_test.git
cd rice_test
```

2. Make the installation script executable:
```bash
chmod +x install.sh
```

3. Run the installation script:
```bash
./install.sh
```

4. Restart your system to ensure all changes take effect:
```bash
reboot
```

5. At the login screen, select "Hyprland" from your session options

## Default Keybindings

Essential shortcuts to get started:
- `SUPER + Return`: Open terminal (kitty)
- `SUPER + Q`: Close active window
- `SUPER + M`: Exit Hyprland
- `SUPER + D`: App launcher (wofi)
- `SUPER + Arrow keys`: Navigate between windows
- `SUPER + 1-9`: Switch workspaces
- `SUPER + SHIFT + 1-9`: Move window to workspace

## Configuration Files

Key configuration files and their purposes:
- `config/hypr/hyprland.conf`: Main Hyprland configuration
- `config/waybar/config`: Waybar layout and modules
- `config/waybar/style.css`: Waybar appearance
- `config/hypr/hyprpaper.conf`: Wallpaper settings

## Customization

### Changing the Wallpaper
Generate a new wallpaper:
```bash
./scripts/generate-wallpaper.sh --width 1920 --height 1080
```

### Reloading the Theme
If you change the wallpaper or want to regenerate colors:
```bash
./scripts/reload-theme.sh
```

### Restarting Waybar
If the bar disappears or needs refresh:
```bash
./scripts/restart-waybar.sh
```

## Troubleshooting

### No Waybar
If Waybar doesn't appear:
1. Open a terminal (`SUPER + Return`)
2. Run: `./scripts/restart-waybar.sh`

### Color Scheme Issues
If colors aren't updating:
1. Check if pywal is installed: `pacman -Qs python-pywal`
2. Run: `./scripts/reload-theme.sh`
3. Verify color files exist: `ls ~/.cache/wal/`

### Display Manager
If SDDM doesn't start:
1. Check if it's enabled: `systemctl status sddm`
2. Enable it manually: `sudo systemctl enable --now sddm`

## Uninstallation

To remove the configuration and restore defaults:
```bash
./uninstall.sh
```

This will:
- Remove installed packages
- Backup existing configurations
- Restore minimal defaults
- Disable the display manager

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is open source and available under the [MIT License](LICENSE).

## Credits
- [Hyprland](https://hyprland.org/) - Wayland compositor
- [pywal](https://github.com/dylanaraps/pywal) - Color scheme generation
- [waybar](https://github.com/Alexays/Waybar) - Status bar
- [ImageMagick](https://imagemagick.org/) - Wallpaper generation