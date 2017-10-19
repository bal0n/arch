#!/bin/bash
# ArchLinux install script

# Funciones

function discos {
	mkfs.ext2 /dev/sda1
	mkfs.ext4 /dev/sda2
	mkswap /dev/sda3
	swapon /dev/sda3

	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
}

function base {
	pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
	genfstab -U -p /mnt >> /mnt/etc/fstab
}

function chroot {
	cp chroot.sh /mnt
	chmod +x /mnt/chroot.sh
	arch-chroot /mnt ./chroot.sh
	umount /mnt/boot
	umount /mnt
}

# Main

loadkeys es
discos

if ping -c1 google.com &> /dev/null; then
	echo OK;
	base;
else
	echo Conexion failed;
	wifi-menu;
fi

chroot
reboot
