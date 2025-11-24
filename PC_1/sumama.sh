#!/usr/bin/env bash

set -e

USER_NAME="andre"
REPO_CONFIG="$HOME/Documents/ArchLinuxPriv/PC_1/.config"
TARGET_CONFIG="$HOME/.config"

echo "=== Copiando configuración (solo carpetas existentes en el repo) ==="
mkdir -p "$TARGET_CONFIG"

for folder in "$REPO_CONFIG"/*; do
    name=$(basename "$folder")
    echo "Copiando carpeta: $name"
    rsync -a --delete "$folder/" "$TARGET_CONFIG/$name/"
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

echo "=== Todo listo! Reinicia para aplicar autologin e inicio automático de Hyprland ==="
