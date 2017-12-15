#!/bin/bash

nombre_de_equipo=vantpc
nombreusuario=javier
passwordusuario=archlinux

function config {
    echo $nombre_de_equipo >> /etc/hostname  
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime  
    echo "LANG=es_ES.UTF-8" >> /etc/locale.conf  
    mv /etc/locale.gen /etc/locale.gen.bk
    echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen 
    locale-gen
    echo "KEYMAP=es" >> /etc/vconsole.conf

    # Configuración de usuario
    useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $nombreusuario
    printf "$passwordusuario\n$passwordusuario" | passwd $nombreusuario

    # Configuración de red
    systemctl enable NetworkManager.service

    # Instalación de Yaourt
    echo -e "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf 
    pacman -Sy yaourt
 
    # Instalación Xorg Server y drivers 
    pacman -Sy --noconfirm $(<packages/xorg.txt)
}

function grub {
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
}

config
grub
mkinitcpio -p linux
passwd
exit
