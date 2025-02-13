#!/bin/bash

# A script to generate Material You inspired color palettes from an image

get_dominant_color() {
    local image="$1"
    magick "$image" -scale 50x50! -depth 8 +dither -colors 8 -format "%c" histogram:info: | \
        sort -nr | head -n 1 | grep -o '#[0-9A-Fa-f]*'
}

generate_material_palette() {
    local base_color="$1"
    local output_file="$2"
    
    # Generate tonal palette using Material You principles
    python3 - << EOF > "$output_file"
import colorsys
import re

def hex_to_hsv(hex_color):
    hex_color = hex_color.lstrip('#')
    r = int(hex_color[:2], 16) / 255
    g = int(hex_color[2:4], 16) / 255
    b = int(hex_color[4:], 16) / 255
    return colorsys.rgb_to_hsv(r, g, b)

def hsv_to_hex(h, s, v):
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return '#{:02x}{:02x}{:02x}'.format(int(r * 255), int(g * 255), int(b * 255))

base = '$base_color'
h, s, v = hex_to_hsv(base)

# Generate Material You tonal palette
colors = {
    'primary': base,
    'on_primary': hsv_to_hex(h, s, 0.1 if v > 0.5 else 0.95),
    'primary_container': hsv_to_hex(h, s * 0.8, v * 1.1),
    'on_primary_container': hsv_to_hex(h, s, 0.1 if v > 0.5 else 0.95),
    'secondary': hsv_to_hex(h, s * 0.7, v),
    'on_secondary': hsv_to_hex(h, s, 0.1 if v > 0.5 else 0.95),
    'background': hsv_to_hex(h, s * 0.1, 0.95 if v > 0.5 else 0.1),
    'on_background': hsv_to_hex(h, s * 0.1, 0.1 if v > 0.5 else 0.95),
    'surface': hsv_to_hex(h, s * 0.1, 0.98 if v > 0.5 else 0.05),
    'on_surface': hsv_to_hex(h, s * 0.1, 0.1 if v > 0.5 else 0.95),
}

print("Material You Color Palette:")
for name, color in colors.items():
    print(f"{name}={color}")
EOF
}

# Default image is the wallpaper
image="${1:-$HOME/.config/hypr/wallpapers/default.jpg}"
output="/tmp/material_colors.txt"

if [ ! -f "$image" ]; then
    echo "Error: Image file not found: $image"
    exit 1
fi

# Get dominant color and generate palette
dominant_color=$(get_dominant_color "$image")
generate_material_palette "$dominant_color" "$output"

# Display the generated palette
cat "$output"

# Generate a preview of the palette
magick convert -size 500x50 xc:none \
    $(awk -F= '/^[^#]/{print "-fill", $2, "-draw", "rectangle", NR*50-50, "0", NR*50, "50"}' "$output") \
    /tmp/palette_preview.png

echo "Palette preview saved to /tmp/palette_preview.png"