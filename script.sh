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

function config {
	echo "vantpc" >> /etc/hostname
	rm /etc/localtime
	ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
	echo "LANG=es_ES.UTF-8" >> /etc/locale.conf
	rm /etc/locale.gen
	echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen
	echo "KEYMAP=es" >> /etc/vconsole.conf
}

function grub {
	grub-install /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg
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

arch-chroot /mnt
#config
#grub
#mkinitcpio -p linux
#passwd
#exit
umount /mnt/boot
umount /mnt
