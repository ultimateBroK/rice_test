#!/bin/bash

# Kiểm tra xem đã chạy với quyền root chưa
if [[ $EUID -ne 0 ]]; then
   echo "Script này cần chạy với quyền root (sudo)."
   exit 1
fi

# Gỡ cài đặt các gói
echo "Gỡ cài đặt Hyprland và các gói liên quan..."
pacman -Rns --noconfirm hyprland waybar xdg-desktop-portal-hyprland \
  swaybg wlr-randr brightnessctl dunst polkit-kde-agent \
  grim slurp wl-clipboard kitty alacritty thunar nwg-look \
  swww network-manager-applet pavucontrol

# Xóa thư mục cấu hình (tùy chọn, cẩn thận!)
# echo "Xóa thư mục cấu hình (thao tác này sẽ xóa cấu hình của bạn!)..."
# rm -rf ~/.config/hypr
# rm -rf ~/.config/waybar

echo "Gỡ cài đặt hoàn tất! Vui lòng khởi động lại để áp dụng thay đổi."