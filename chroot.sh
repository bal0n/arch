#!/bin/bash

# Variables
nEquipo=arch
nUsuario=javier
pUsuario=archlinux
pRoot=archlinux
nGit=franciscodejavier
repoGit=Arch

# Funciones
function configGeneral {
    echo $nEquipo >> /etc/hostname
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
    echo "LANG=es_ES.UTF-8" >> /etc/locale.conf
    mv /etc/locale.gen /etc/locale.gen.bk
    echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    echo "KEYMAP=es" >> /etc/vconsole.conf
}

function configUsuario {
    # Configuración de usuario
    useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $nUsuario
    printf "$pUsuario\n$pUsuario" | passwd $nUsuario
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
}

function configRed {
    # Configuración de red
    systemctl enable NetworkManager.service
}

function configYaourt {
    # Instalación de Yaourt
    echo -e "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
    pacman -Sy yaourt
}

function instalServer {
    # Instalación Xorg Server y drivers
    pacman -Sy --noconfirm $(<pckgs/xorg.txt)

    # Instalación etc
    pacman -Sy --noconfirm $(<pckgs/etc.txt)
    xdg-user-dirs-update
}

function instalAwesome {
    pacman -Sy --noconfirm $(<pckgs/awesome.txt)
}

function configGrub {
    grub-install /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
}

function getFiles {
    git clone https://github.com/$nGit/$repoGit.git
    mv $repoGit/files/.nanorc ~/.nanorc
    mv $repoGit/files/.bashrc ~/.bashrc
    mv $repoGit/files/.xbindkeysrc ~/.xbindkeysrc
    mv $repoGit/files/.xinitrc ~/.xinitrc
    mv $repoGit/files/etc/X11/xorg.conf.d/10-keyboard.conf /etc/X11/xorg.conf.d/10-keyboard.conf
    mv $repoGit/files/etc/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
    mkdir ~/.config/termite
    mv $repoGit/files/.config/termite/config ~/.config/termite/config
    rm -R files
}

# Guión
configGeneral
configUsuario
configRed
configYaourt
instalServer
instalAwesome
configGrub
getFiles

mkinitcpio -p linux
printf "$pRoot\n$pRoot" | passwd
exit
