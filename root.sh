#!/bin/bash

# Variables
keys=es
chr=chroot.sh
pckgs=pckgs
boot=/dev/sda1 #/dev/nvme0n1p1
root=/dev/sda2 #/dev/nvme0n1p2
home=/dev/sda3 #/dev/nvme0n1p3
swap=/dev/sda4 #/dev/nvme0n1p4
uefi=false

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


# Formato y administración de discos.
# Esta función presupone el siguiente particionado de disco:

#     boot /dev/sda1	  /boot	  150MB	*Bootable
#     root /dev/sda2	  /	  –
#     home /dev/sda3	  /home	  - 
#     swap /dev/sda4	  /swap	  2GB	* Type: Linux Swap / Solaris

# Se puede obtener con el comando cfdisk antes de ejecutar el script.
# !Función pendiente de automatizar.
function adminDiscos {
    log info "Iniciando administración de discos"
    if [  $uefi = true ]; then
        mkfs.vfat -F32 $boot
        log ok "$boot BOOT formateado en modo UEFI "
    else
        mkfs.ext2 $boot
        log ok "$boot BOOT formateado en modo BIOS "
    fi

    mkfs.ext4 $root
    log ok "$root ROOT formateado"
    mkfs.ext4 $home
    log ok "$home HOME formateado"
    mkswap $swap
    swapon $swap
    log ok "$swap SWAP configurado"
    mount $root /mnt
    log ok "$root ROOT montado en /mnt"

    if [  $uefi = true ]; then
        mkdir -p /mnt/boot/efi
        mount $boot /mnt/boot/efi
        log ok "$boot BOOT montado en /mnt/boot/efi (UEFI)"
    else
        mkdir /mnt/boot
        mount $boot /mnt/boot
        log ok "$boot BOOT montado en /mnt/boot (BIOS)"
    fi

    mkdir /mnt/home
    mount $home /mnt/home
    log ok "$home HOME montado en /mnt/home"
}

# Instalación base del sistema operativo y generación del fstab.
# !Pendiente de extraer los paquetes para una mayor escala y abtracción.
function instalacionBase {
    log info "Inicialización e instalación de sistema base"
    pacstrap /mnt linux linux-firmware base base-devel networkmanager xf86-input-synaptics grub ntfs-3g gvfs xdg-user-dirs nano wpa_supplicant dialog
    if [  $uefi = true ]; then
        pacstrap /mnt efibootmgr
    fi
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

# Acceso a jaula chroot de carpeta root del sistema (/mnt)
function jaulaChroot {
    cp $chr /mnt
    cp $pckgs /mnt
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
        log ok "Conexión correcta";
        conexion=true;
    else
	    wifi-menu;
    fi
done
instalacionBase
jaulaChroot
reboot