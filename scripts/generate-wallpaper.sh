#!/bin/bash

# Default values
WIDTH=1920
HEIGHT=1200
STYLE="geometric"
COLOR1="#1a1b26"
COLOR2="#24283b"
ACCENT="#7aa2f7"
OUTPUT="$HOME/.config/hypr/wallpapers/default.jpg"

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
    magick -size "${WIDTH}x${HEIGHT}" \
        -define gradient:vector="0,0 ${WIDTH},${HEIGHT}" \
        -define gradient:angle=45 \
        gradient:"${COLOR1}-${COLOR2}" \
        -fill "${ACCENT}" \
        -stroke "${ACCENT}" \
        -strokewidth 2 \
        -draw "path 'M 0,0 L ${WIDTH},0 L ${WIDTH},${HEIGHT} L 0,${HEIGHT} Z M ${WIDTH}*0.1,${HEIGHT}*0.15 L ${WIDTH}*0.9,${HEIGHT}*0.15 L ${WIDTH}*0.9,${HEIGHT}*0.85 L ${WIDTH}*0.1,${HEIGHT}*0.85 Z'" \
        -draw "path 'M ${WIDTH}*0.15,${HEIGHT}*0.25 L ${WIDTH}*0.85,${HEIGHT}*0.25 L ${WIDTH}*0.85,${HEIGHT}*0.75 L ${WIDTH}*0.15,${HEIGHT}*0.75 Z'" \
        -blur 0x2 \
        "${OUTPUT}"
}

generate_waves() {
    magick -size "${WIDTH}x${HEIGHT}" \
        -define gradient:vector="0,0 ${WIDTH},${HEIGHT}" \
        gradient:"${COLOR1}-${COLOR2}" \
        \( -size "${WIDTH}x${HEIGHT}" \
            -seed 1337 \
            plasma:fractal \
            -blur 0x2 \
            -level 0,50% \
            -fill "${ACCENT}" \
            -colorize 50% \
        \) \
        -compose screen \
        -composite \
        "${OUTPUT}"
}

generate_dots() {
    magick -size "${WIDTH}x${HEIGHT}" \
        -define gradient:vector="0,0 ${WIDTH},${HEIGHT}" \
        gradient:"${COLOR1}-${COLOR2}" \
        \( -size "${WIDTH}x${HEIGHT}" \
            xc: -seed 1337 \
            -sparse-color voronoi "0,0 ${ACCENT} ${WIDTH},${HEIGHT} ${ACCENT}" \
            -blur 0x3 \
            -level 0,50% \
        \) \
        -compose screen \
        -composite \
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

# Generate wallpaper based on style
case "${STYLE}" in
    geometric) generate_geometric ;;
    waves) generate_waves ;;
    dots) generate_dots ;;
    *) echo "Unknown style: ${STYLE}"; show_help; exit 1 ;;
esac

# Update pywal colors
wal -i "${OUTPUT}"

echo "Wallpaper generated at: ${OUTPUT}"
echo "Color scheme updated with pywal"