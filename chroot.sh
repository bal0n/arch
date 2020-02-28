#!/bin/bash

# Variables
hostname=arch
username=balon
passu=archlinux
passroot=archlinux
pckgs=pckgs
scriptsDir=scripts
uefi=false

# Funciones
function installPckgs {

    #    Backup de paquetes instalados
    #    # pacman -Qqe > pkglist.txt
    #    (Nota: Si se usó la opción -t al reinstalar la lista, todos los paquetes que no 
    #    sean de nivel superior se establecerán como dependencias. Con la opción -n, los 
    #    paquetes externos (por ejemplo, de AUR) se omitirán de la lista.)
        
    #    Reinstalación de paquetes de backup
    #    # pacman -S - < pkglist.txt

    pacman -Sy --noconfirm $(<pckgs)
}


function scriptsRocket {
    sh $scripts/*.sh
}

function configGeneral {
    echo $hostname >> /etc/hostname
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
    echo "LANG=es_ES.UTF-8" >> /etc/locale.conf
    mv /etc/locale.gen /etc/locale.gen.bk
    echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    echo "KEYMAP=es" >> /etc/vconsole.conf
    # Instalación de directorios personales
    #xdg-user-dirs-update
    hwclock -w
}

function configUsuario {
    # Configuración de usuario
    useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $username
    printf "$passu\n$passu" | passwd $username
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
}

function configRed {
    # Configuración de red
    systemctl enable NetworkManager.service
}


# YAOURT HA MUERTO
#function configYaourt {
#    # Instalación de Yaourt
#    echo -e "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
#    pacman -Sy yaourt
#}


# Configuración de Grub
function configGrub {
    if [  $uefi = true ]; then
        grub-install --efi-directory=/boot/efi --bootloader-id='Arch Linux' --target=x86_64-efi
    else
        grub-install /dev/sda
    fi

    grub-mkconfig -o /boot/grub/grub.cfg
}

# DEPRECATED
function getFiles {
    sh deployment.sh
}

# Guión
installPckgs
configGeneral
configUsuario
configRed
configGrub
#getFiles

mkinitcpio -p linux
printf "$passroot\n$passroot" | passwd
exit