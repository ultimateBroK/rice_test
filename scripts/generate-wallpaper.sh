#!/bin/bash

# Exit on error
set -e

# Default values
WIDTH=1920
HEIGHT=1080
STYLE="geometric"
COLOR1="#1a1b26"
COLOR2="#24283b"
ACCENT="#7aa2f7"
OUTPUT="$HOME/.config/hypr/wallpapers/default.jpg"

# Make sure imagemagick is installed
if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -w, --width WIDTH      Wallpaper width (default: 1920)"
    echo "  -h, --height HEIGHT    Wallpaper height (default: 1200)"
    echo "  -s, --style STYLE      Pattern style: geometric, waves, dots (default: geometric)"
    echo "  -c1, --color1 COLOR    First gradient color (default: #1a1b26)"
    echo "  -c2, --color2 COLOR    Second gradient color (default: #24283b)"
    echo "  -a, --accent COLOR     Accent color (default: #7aa2f7)"
    echo "  -o, --output PATH      Output path (default: ~/.config/hypr/wallpapers/default.jpg)"
    echo "  --help                 Show this help message"
}

generate_geometric() {
    echo "Generating geometric wallpaper..."
    # Create a more complex gradient wallpaper that pywal can extract colors from
    magick convert \( -size "${WIDTH}x${HEIGHT}" \
        -define gradient:angle=45 \
        gradient:"${COLOR1}-${COLOR2}" \) \
        \( -size "${WIDTH}x${HEIGHT}" \
        -define gradient:angle=135 \
        gradient:"${ACCENT}00-${ACCENT}44" \) \
        -compose over -composite \
        -blur 0x2 \
        "${OUTPUT}"
    
    # Add some visual elements for better color extraction
    magick convert "${OUTPUT}" \
        \( -size "${WIDTH}x${HEIGHT}" xc:none \
        -draw "fill ${ACCENT}22 roundrectangle $(($WIDTH/4)),$(($HEIGHT/4)) $(($WIDTH*3/4)),$(($HEIGHT*3/4)) 20,20" \
        -draw "fill ${COLOR2}33 roundrectangle $(($WIDTH/3)),$(($HEIGHT/3)) $(($WIDTH*2/3)),$(($HEIGHT*2/3)) 40,40" \
        -draw "fill ${COLOR1}44 circle $(($WIDTH/2)),$(($HEIGHT/2)) $(($WIDTH/2)),$(($HEIGHT/2-100))" \
        \) \
        -compose over -composite \
        "${OUTPUT}"
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -w|--width) WIDTH="$2"; shift 2 ;;
        -h|--height) HEIGHT="$2"; shift 2 ;;
        -s|--style) STYLE="$2"; shift 2 ;;
        -c1|--color1) COLOR1="$2"; shift 2 ;;
        -c2|--color2) COLOR2="$2"; shift 2 ;;
        -a|--accent) ACCENT="$2"; shift 2 ;;
        -o|--output) OUTPUT="$2"; shift 2 ;;
        --help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

# Create output directory if it doesn't exist
mkdir -p "$(dirname "${OUTPUT}")"
chmod 755 "$(dirname "${OUTPUT}")"

# Generate wallpaper based on style
case "${STYLE}" in
    geometric) generate_geometric ;;
    *) echo "Unknown style: ${STYLE}"; show_help; exit 1 ;;
esac

# Verify the wallpaper was created
if [ ! -f "${OUTPUT}" ]; then
    echo "Error: Failed to generate wallpaper at ${OUTPUT}"
    exit 1
fi

# Initialize pywal with the generated wallpaper
if command -v wal &> /dev/null; then
    echo "Initializing pywal with generated wallpaper..."
    # Use backend that works better with gradients
    wal --backend colorz --saturate 1.0 -i "${OUTPUT}" -n || \
    wal --backend haishoku --saturate 1.0 -i "${OUTPUT}" -n || \
    echo "Warning: Failed to initialize pywal"
fi

echo "Wallpaper generated successfully at: ${OUTPUT}"