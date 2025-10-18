Es necesario la instalacion de varias partes, empezando por hyprland y sus complementos
Estando desde la consola 

Clave el yay:
```
git clone https://aur.archlinux.org/yay.git
```
```
cd yay
```
```
makepkg -si
```
```
sudo pacman -Syu git base-devel
```
```
yay -S hyprland
```
Instlacion de complementos clave
```
sudo pacman -S xdg-desktop-portal-hyprland polkit \
    waybar rofi alacritty wl-clipboard grim slurp \
    dolphin pavucontrol brightnessctl \
    network-manager-applet
```

Copiamos el primero (despues hacemos magia)
```
mkdir -p ~/.config/hypr
cp /usr/share/hyprland/hyprland.conf ~/.config/hypr/
```

Para el inicio automatico vamos a modificar el archivo:

```
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
```
```
[Service]
ExecStart
ExecStart=-/sbin/agetty --autologin Haider --noclear %I $TERM
```

Modificamos el arranque:

```
nano ~/.bash_profile
```
```
# ~/.bash_profile

[[ ~f ~/.bashrc 1] & . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
  exec Hyprland
fi
```

Para administrar la grafica:
```
sudo pacman -S nvidia nvidia-utils nvidia-settings
sudo pacman -S nvidia-dkms
```

Creamos el script:
```
sudo nano ~/scripts/nvidia-fan-curve.sh
```

Y le agregamos:
```
#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/Haider/.Xauthority

sleep 10

while true; do
    if ! nvidia-smi > /dev/null 2>&1; then
        echo "Error: nvidia-smi no disponible"
        sleep 30
        continue
    fi

    TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    
    if [ -z "$TEMP" ] || [ "$TEMP" -lt 0 ] || [ "$TEMP" -gt 100 ]; then
        echo "Error: Temperatura inválida: $TEMP"
        sleep 10
        continue
    fi

    if [ "$TEMP" -lt 20 ]; then
        SPEED=30
    elif [ "$TEMP" -lt 25 ]; then
        SPEED=45
    elif [ "$TEMP" -lt 30 ]; then
        SPEED=60
    elif [ "$TEMP" -lt 35 ]; then
        SPEED=75
    else
        SPEED=90
    fi

    echo "Temperatura: ${TEMP}°C - Velocidad ventilador: ${SPEED}%"

    env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
        nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \
        -a "[fan:0]/GPUTargetFanSpeed=${SPEED}" > /dev/null 2>&1

    sleep 10
done
```
Ahora necesitamos instalar:
```
sudo pacman -S expect
```
Y tambien creamos el archivo:
```
sudo nano ~/scripts/init-root.sh
```
Y le agregamos:
```
#!/usr/bin/expect -f
spawn su -c "/home/Haider/scripts/nvidia-fan-curve.sh"
expect "Password:"
send "1112\r"
interact
```

Ahora vamos a instalar mas herramientas:
```
yay -S swww
yay -S eww
sudo pacman -S slurp
sudo pacman -S tesseract tesseract-data-eng
sudo pacman -S wl-clipboard
sudo pacman -S pamixer
sudo pacman -S brightnessctl
sudo pacman -S firefox
sudo pacman -S lxappearance
yay -S discord
yay -S visual-studio-code-bin
yay -S spotify
yay -S trello
yay -s steam
yay -S postman
yay -S dbeaver
yay -S heroic-games-launcher-bin
```
Variables de entorno:
```
sudo nano ~/.bashrc
```

```
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export JAVA_HOME=/opt/microsoft-jdk-21
export PATH=$JAVA_HOME/bin:$PATH


runbg() {
    nohup "$@" > /dev/null 2>&1 &
}

eval "$(ssh-agent -s)" > /dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null
export PATH=$PATH:$HOME/.local/bin


export DB_SARABI_URL=jdbc:postgresql://tramway.proxy.rlwy.net:20899/railway
export DB_SARABI_USER=postgres

export DB_SARABI_PASSWORD=NhlZerRxUFDtHJtGJxwFzGtbQnwUkIGG
```
Ahora para la gestion de temas debemos instalar el tema de Dracula:

```
yay -S dracula-gtk-theme
```

y haciendo uso de 

```
lxappearance
```

Cambiamos el tema a dracula, aparte de esto es importante recordar que se debe copiar todo lo de config de este repositorio
```
```
```
```