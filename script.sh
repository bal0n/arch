#!/bin/bash



function adminDiscos {

    # Prólogo
    mkfs.ext2 /dev/sda1
    mkfs.ext4 /dev/sda2
    mkswap /dev/sda3
    swapon /dev/sda3

    # Nudo
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
}

function instalacionBase {
    pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

function jaulaChroot {
    cp chroot.sh /mnt
    chmod +x /mnt/chroot.sh
    arch-chroot /mnt ./chroot.sh
    umount /mnt/boot
    umount /mnt
}

# Main

loadkeys es
adminDiscos

if ping -c1 google.com &> /dev/null; then
    echo OK;
    instalacionBase;
else
    echo Conexion failed;
    wifi-menu;
fi

jaulaChroot
reboot
