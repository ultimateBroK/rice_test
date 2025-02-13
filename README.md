# Material You Hyprland Configuration

A modern, Material You-inspired Hyprland configuration with dynamic theming, smooth animations, and an elegant user interface.

![Preview Coming Soon]()

## Features

- 🎨 **Material You Dynamic Theming**
  - Automatically generates color schemes from your wallpaper
  - Consistent color palette across all UI elements
  - Smooth color transitions when theme changes

- 🖼️ **Dynamic Wallpaper Generation**
  - Three distinct styles: geometric, waves, and dots
  - Material Design inspired patterns
  - Auto-generated color harmonies
  - Custom resolution support

- 🎯 **Optimized Multi-Monitor Setup**
  - Pre-configured for dual monitor setup
  - Primary: 1920x1200 @ 60Hz (bottom)
  - Secondary: 1920x1080 @ 75Hz (top)
  - Smart workspace distribution

- ⚡ **Modern Animations**
  - Smooth window transitions
  - Material Design-inspired bezier curves
  - Workspace sliding animations
  - Fade effects for popups

- 🛠️ **Enhanced Input Configuration**
  - Optimized touchpad gestures
  - Natural scrolling
  - Multi-touch support
  - US keyboard layout

- 📊 **Modern Waybar Configuration**
  - Material You styling
  - Dynamic module backgrounds
  - Smooth transitions
  - Useful system information

## Requirements

- Arch Linux or compatible distribution
- Basic system development tools
- ImageMagick for wallpaper generation
- Python 3.6+ for color processing

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/rice_test.git
   cd rice_test
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

3. Log out and select Hyprland from your display manager

## Configuration

### Generating New Wallpapers

```bash
./scripts/generate-wallpaper.sh [options]

Options:
  -w, --width WIDTH      Wallpaper width (default: 1920)
  -h, --height HEIGHT    Wallpaper height (default: 1200)
  -s, --style STYLE      Pattern style: geometric, waves, dots
  -c1, --color1 COLOR    First gradient color
  -c2, --color2 COLOR    Second gradient color
  -a, --accent COLOR     Accent color
  -o, --output PATH      Output path
```

### Random Theme Generation

Generate a random Material You theme:
```bash
./scripts/random-theme.sh
```

### Material You Color Palette

Generate a Material You color palette from any image:
```bash
./scripts/generate-material-palette.sh [image_path]
```

## Directory Structure

```
.
├── config/
│   ├── hypr/           # Hyprland configuration
│   ├── waybar/         # Waybar configuration
│   └── wal/            # Pywal templates
├── scripts/            # Utility scripts
└── install.sh          # Installation script
```

## Customization

### Hyprland Configuration
Edit `config/hypr/hyprland.conf` to customize:
- Window behaviors
- Keybindings
- Animations
- Monitor layout

### Waybar Customization
Edit `config/waybar/config` to:
- Add/remove modules
- Change module positions
- Modify click actions

Edit `config/waybar/style.css` to:
- Change colors
- Modify spacing
- Adjust borders
- Update transitions

## Keybindings

Default keybindings follow standard Hyprland configuration:
- `SUPER + Return`: Open terminal
- `SUPER + Q`: Close window
- `SUPER + 1-9`: Switch workspaces
- `SUPER + SHIFT + 1-9`: Move window to workspace
- `SUPER + Arrow keys`: Navigate windows
- `SUPER + D`: App launcher (wofi)

## Uninstallation

To remove the configuration and restore defaults:
```bash
./uninstall.sh
```

## Troubleshooting

If colors aren't updating:
1. Ensure pywal is installed
2. Run `./scripts/reload-theme.sh`
3. Check `~/.cache/wal` for generated color files

If wallpaper generation fails:
1. Verify ImageMagick is installed
2. Check write permissions in output directory
3. Ensure all dependencies are installed

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- [Hyprland](https://hyprland.org/) for the amazing Wayland compositor
- [pywal](https://github.com/dylanaraps/pywal) for color scheme generation
- Material Design team for design inspiration