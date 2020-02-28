#!/bin/bash

# Variables
keys=es
chr=chroot.sh
boot=/dev/nvme0n1p1 #/dev/sda1
root=/dev/nvme0n1p2 #/dev/sda2
home=/dev/nvme0n1p3 #/dev/sda3
swap=/dev/nvme0n1p4 #/dev/sda4

'''
    Formato y administración de discos.
    Esta función presupone el siguiente particionado de disco:
    
        boot /dev/sda1	  /boot	  150MB	*Bootable
        root /dev/sda2	  /	  –
        home /dev/sda3	  /home	  - 
        swap /dev/sda4	  /swap	  2GB	* Type: Linux Swap / Solaris

    Se puede obtener con el comando cfdisk antes de ejecutar el script.
    !Función pendiente de automatizar.
'''
function adminDiscos {
    # TODO: Revisar UEFI
    mkfs.ext2 $boot
    mkfs.ext4 $root
    mkfs.ext4 $home
    mkswap $swap
    swapon $swap
    mount $root /mnt
    # TODO: Revisar UEFI
    mkdir /mnt/boot
    mkdir /mnt/home
    mount $boot /mnt/boot
    mount $home /mnt/home
}

'''
    Instalación base del sistema operativo y generación del fstab.
    !Pendiente de extraer los paquetes para una mayor escala y abtracción.
'''
function instalacionBase {
    pacstrap /mnt linux linux-firmware base base-devel networkmanager xf86-input-synaptics
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

'''
    Acceso a jaula chroot de carpeta root del sistema (/mnt)
'''
function jaulaChroot {
    cp $chr /mnt
    chmod +x /mnt/$chr
    arch-chroot /mnt ./$chr
    umount /mnt/boot
    umount /mnt/home
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