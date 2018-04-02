# Guión de instalación de Arch usando scripts
## En formación
### No fiable
	git clone https://github.com/franciscodejavier/arch.git arch
	cd arch
	sh script.sh
	git clone https://github.com/franciscodejavier.arch.git arch
	cd arch 
	sh config.sh

# Guión manual de instalación

Disco duro

	loadkeys
	cfdisk
		/dev/sda1	  /boot	  150MB	*Bootable
		/dev/sda2	  /	  –
		/dev/sda3	  /home	  - 
		/dev/sda4	  /swap	  2GB	* Type: Linux Swap / Solaris

	mkfs.ext2 /dev/sda1
	mkfs.ext4 /dev/sda2
	mkfs.ext4 /dev/sda3
	mkswap /dev/sda4
	swapon /dev/sda4
	
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mkdir /mnt/home
	mount /dev/sda1 /mnt/boot
	mount /dev/sda3 /mnt/home

Sistema base

	wifi-menu
	ping 8.8.8.8
	pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
	genfstab -U -p /mnt >> /mnt/etc/fstab
	arch-chroot /mnt

Configuracuión inicial en chroot

	echo “nombre-de-equipo” >> /etc/hostname
	ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
	echo “LANG=es_ES.UTF-8” >> /etc/locale.conf
	nano /etc/locale.gen
	locale-gen
	echo “KEYMAP=es” >> /etc/vconsole.conf

	grub-install /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg

	mkinitcpio -p linux

	passwd
	exit

	umount /mnt/boot
	umount /mnt/home
	reboot

Configuración inicial con root

	systemctl start NetworkManager.service
	systemctl enable NetworkManager.service
	useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash nombre-de-usuario
	passwd nombre-de-usuario
	nano /etc/sudoers
	reboot

Configuración inicial con usuario

	sudo nmcli dev wifi connect SSID password PASSWORD
	sudo pacman -Syu
