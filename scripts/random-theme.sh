#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Generate random Material Design colors
generate_random_material_colors() {
    # Generate a random hue (0-360)
    hue=$((RANDOM % 360))
    
    # Use predefined Material Design saturation and value ranges
    saturation=$((60 + RANDOM % 20))  # 60-80%
    value=$((85 + RANDOM % 10))       # 85-95%
    
    # Convert HSV to RGB using Python
    python3 - << EOF
import colorsys
h, s, v = $hue/360, $saturation/100, $value/100
r, g, b = colorsys.hsv_to_rgb(h, s, v)
r, g, b = int(r*255), int(g*255), int(b*255)
print(f"#{r:02x}{g:02x}{b:02x}")
EOF
}

# Generate wallpaper with random Material You colors
accent_color=$(generate_random_material_colors)
bg_color1=$(generate_random_material_colors)
bg_color2=$(generate_random_material_colors)

# Generate wallpaper with random style
styles=("geometric" "waves" "dots")
random_style=${styles[$RANDOM % ${#styles[@]}]}

"$SCRIPT_DIR/generate-wallpaper.sh" \
    --style "$random_style" \
    --color1 "$bg_color1" \
    --color2 "$bg_color2" \
    --accent "$accent_color"

# Generate and show Material You palette
"$SCRIPT_DIR/generate-material-palette.sh"

# Show notification
notify-send "Theme Updated" "Generated new Material You theme with $random_style style"