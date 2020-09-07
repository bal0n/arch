#!/bin/bash

# Variables
hostname=arch           # Nombre de equipo
username=username       # Nombre de usuario
passu=archlinux         # Contraseña de usuario
passroot=archlinux      # Contraseña de root
pckgs=pckgs             # Fichero de paquetes
uefi=false              # Modo UEFI o BIOS
scriptsDir=scripts

RED='\033[0;31m'
BLUE="\033[0;34m"
GREEN="\033[0;32m"
NC='\033[0m' # No Color
verbose=true

log() {
    if [  $verbose = true  ]; then
        type=$1
        msg=$2
        time=$(date '+%d/%m/%Y %H:%M:%S')
        color=$BLUE

        if [  $type = "ok"  ]; then
            color=$GREEN
        else 
            if [  $type = "error"  ]; then
                color=$RED
            fi
        fi

        echo -e "$time ${color}[$type]${NC} $msg"
        if [  $type = "error"  ]; then
            exit 1
        fi
    fi
}

# Funciones
function installPckgs {

    #    Backup de paquetes instalados
    #    # pacman -Qqe > pkglist.txt
    #    (Nota: Si se usó la opción -t al reinstalar la lista, todos los paquetes que no 
    #    sean de nivel superior se establecerán como dependencias. Con la opción -n, los 
    #    paquetes externos (por ejemplo, de AUR) se omitirán de la lista.)
        
    #    Reinstalación de paquetes de backup
    #    # pacman -S - < pkglist.txt

    log info "Inicialización de instalación de paquetes"
    pacman -Sy --noconfirm $(<pckgs)
}


function scriptsRocket {
    log info "Lanzamiento de scripts alojados en scripts/"
    sh $scripts/*.sh
}

function configGeneral {
    log info "Actualización de hostname"
    echo $hostname >> /etc/hostname
    log info "Inicialización de configuración de tiempo"
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
    log ok "localtime"
    echo "LANG=es_ES.UTF-8" >> /etc/locale.conf
    log ok "locale.conf"
    mv /etc/locale.gen /etc/locale.gen.bk
    echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
    log ok "locale.gen"
    locale-gen
    echo "KEYMAP=es" >> /etc/vconsole.conf
    log ok "vconsole.conf"
    # Instalación de directorios personales
    #xdg-user-dirs-update
    pacman -S --noconfirm acpid
    log info "Inicialización de instalación de paquetes"
    hwclock -w
    log ok "hwclock"
    systemctl enable acpid.service
}

function configUsuario {
    # Configuración de usuario
    log info "Iniciada configuración de usuario"
    useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $username
    log ok "Usuario creado"
    printf "$passu\n$passu" | passwd $username
    log ok "Contraseña de usuario implementada"
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    log ok "Usuario añadido al grupo sudoers mediante el grupo wheels"
}

function configRed {
    # Configuración de red
    systemctl enable NetworkManager.service
}


function configAUR {
    cd /tmp
    
    # gpg --recv-key 465022E743D71E39
    # git clone https://aur.archlinux.org/aurman.git
    # cd aurman
    # makepkg -si
    # sudo sed -i '/^#Color/s/^#//' /etc/pacman.conf
    # aurman -Syu
    # log ok "aurman instalado"

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    yay -Syu
    log ok "yay instalado"
}


# Configuración de Grub
function configGrub {
    if [  $uefi = true ]; then
        log info "grub en modo UEFI"
        grub-install --efi-directory=/boot/efi --bootloader-id='Arch Linux' --target=x86_64-efi
    else
        log info "grub en modo BIOS"
        grub-install /dev/sda # TODO: GRUB se instala a pelo en SDA, cambiar por variable
    fi

    grub-mkconfig -o /boot/grub/grub.cfg
    log ok "GRUB instalado correctamente"
}

# Guión
installPckgs
configGeneral
configUsuario
configRed
#configAUR # ERROR: Running makepg as root is not allowed as it can use permanent, catastrophic damage to your system.
configGrub

mkinitcpio -p linux
log ok "mkinitcpio"
printf "$passroot\n$passroot" | passwd
exit