#!/bin/bash

nombre_de_equipo=vantpc

function config {
	echo $nombre_de_equipo >> /etc/hostname  
	rm /etc/localtime
	ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime  
	echo "LANG=es_ES.UTF-8" >> /etc/locale.conf  
  mv /etc/locale.gen /etc/locale.gen.bk
	echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen 
	locale-gen
	echo "KEYMAP=es" >> /etc/vconsole.conf
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
