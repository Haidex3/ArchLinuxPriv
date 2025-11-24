#!/usr/bin/env bash

set -e

USER_NAME="Haider"
REPO_URL="https://github.com/Haidex3/ArchLinuxPriv"
TARGET_DIR="$HOME/Documents/ArchLinuxPriv"
CONFIG_SOURCE="$TARGET_DIR/PC_1/.config"
CONFIG_TARGET="$HOME/.config"

echo "=== Instalando paquetes necesarios ==="
sudo pacman -S --needed xdg-desktop-portal-hyprland polkit \
    waybar rofi alacritty wl-clipboard grim slurp \
    dolphin pavucontrol brightnessctl network-manager-applet -y

echo "=== Clonando repositorio en ~/Documents ==="
mkdir -p "$HOME/Documents"
if [ -d "$TARGET_DIR" ]; then
    echo "El repositorio ya existe, actualizando..."
    git -C "$TARGET_DIR" pull
else
    git clone "$REPO_URL" "$TARGET_DIR"
fi

echo "=== Copiando configuración (solo carpetas existentes en el repo) ==="
mkdir -p "$CONFIG_TARGET"

for folder in "$CONFIG_SOURCE"/*; do
    name=$(basename "$folder")
    echo "Copiando carpeta: $name"
    rsync -a --delete "$folder/" "$CONFIG_TARGET/$name/"
done

echo "=== Configurando autologin en TTY1 ==="
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

sudo bash -c "cat > /etc/systemd/system/getty@tty1.service.d/override.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF

echo "=== Configurando ~/.bash_profile para inicio automático de Hyprland ==="

cat > "$HOME/.bash_profile" <<'EOF'
# ~/.bash_profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
  exec Hyprland
fi
EOF

echo "=== Script completado 🎉 ==="
echo "Reinicia para que el autologin e inicio de Hyprland se apliquen."
