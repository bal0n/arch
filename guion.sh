#!/bin/bash

# Variables
keys=es
scriptChroot=chroot.sh

# Funciones
function adminDiscos {
    mkfs.ext2 /dev/sda1
    mkfs.ext4 /dev/sda2
    mkswap /dev/sda3
    swapon /dev/sda3
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
}

function instalacionBase {
    pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

function jaulaChroot {
    cp $scriptChroot /mnt
    chmod +x /mnt/$scriptChroot
    arch-chroot /mnt ./$scriptChroot
    umount /mnt/boot
    umount /mnt
}

# Guión
loadkeys $keys
adminDiscos
conexion=false
while [  $conexion = false ]; do
    if ping -c1 google.com &> /dev/null; then
	echo "Conexión correcta";
	conexion=true;
    else
	wifi-menu;
    fi
done
instalacionBase
jaulaChroot
reboot
