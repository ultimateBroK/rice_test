#!/bin/bash

# Kiểm tra xem đã chạy với quyền root chưa
if [[ $EUID -ne 0 ]]; then
   echo "Script này cần chạy với quyền root (sudo)."
   exit 1
fi

# Cập nhật hệ thống
echo "Cập nhật hệ thống..."
pacman -Syu --noconfirm

# Cài đặt Hyprland và các gói cần thiết
echo "Cài đặt Hyprland và các gói phụ thuộc..."
pacman -S --noconfirm hyprland waybar xdg-desktop-portal-hyprland \
  swaybg wlr-randr brightnessctl dunst polkit-kde-agent \
  grim slurp wl-clipboard

# (Tùy chọn) Cài đặt các công cụ hữu ích khác
echo "Cài đặt các công cụ hữu ích (tùy chọn)..."
pacman -S --noconfirm kitty alacritty thunar nwg-look \
  swww network-manager-applet pavucontrol

# Tạo thư mục cấu hình nếu chưa có
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar

# (Tùy chọn) Sao chép file cấu hình mẫu
# Lưu ý: Bạn nên tự tạo file cấu hình của riêng mình
# cp /usr/share/doc/hyprland/example/hyprland.conf ~/.config/hypr/hyprland.conf
# cp /usr/share/doc/waybar/config ~/.config/waybar/config
# cp /usr/share/doc/waybar/style.css ~/.config/waybar/style.css

echo "Cài đặt hoàn tất! Vui lòng khởi động lại để áp dụng thay đổi."
echo "Bạn có thể cần cấu hình Hyprland và Waybar trong ~/.config/hypr/ và ~/.config/waybar/"