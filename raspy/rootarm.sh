#!/bin/bash

# root/root at init
hostname=arch
username=balon
passu=archlinux
passroot=archlinux
pckgs=pckgs

# TODO WIFI
function wifi {}

# Setup Swap
function setupSwap {
	fallocate -l 1024M /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo 'vm.swappiness=1' > /etc/sysctl.d/99-sysctl.conf
	echo "/swapfile none swap defaults 0 0" >> /etc/fstab # fstab
}

function initPacman {
	pacman-key --init
	pacman-key --populate archlinuxarm
	pacman -S archlinux-keyring
	pacman -Sy pacman
	pacman -Syu
	sed -i 's/#Color/Color/' /etc/pacman.conf
}

# Funciones
function installPckgs {
	'''
        Backup de paquetes instalados
        # pacman -Qqe > pkglist.txt
        (Nota: Si se usó la opción -t al reinstalar la lista, todos los paquetes que no 
        sean de nivel superior se establecerán como dependencias. Con la opción -n, los 
        paquetes externos (por ejemplo, de AUR) se omitirán de la lista.)
        
        Reinstalación de paquetes de backup
        # pacman -S - < pkglist.txt
    '''
    pacman -Sy --noconfirm $(<pckgs)
}

function setupUser {
	printf "$passroot\n$passroot" | passwd
	useradd -d /home/$username -m -G wheel -s /bin/bash $username
	printf "$passu\n$passu" | passwd $username
	echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
	userdel alarm
}

function setupBluetooth {
	mkdir builds 
	cd builds/
	git clone https://aur.archlinux.org/hciattach-rpi3.git # Clone the repository
	cd hciattach-rpi3/
	makepkg -si # Build the package
	git clone https://aur.archlinux.org/pi-bluetooth.git
	cd pi-bluetooth
	makepkg -si
	sudo systemctl start bluetooth.service
}

function fstabRoot {
	echo "/dev/root  /  ext4  defaults,nodiratime,noatime,discard  0  0" >> /etc/fstab # fstab
}

loadkeys es
setupSwap
initPacman
installPckgs
setUser
#setupBluetooth
fstabRoot
reboot