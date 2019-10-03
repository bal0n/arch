*Arch GNU/Linux* es una distribución *GNU/Linux* de propósito general con una instalación por defecto que deja un sistema de base mínima. Los scripts aquí alojados permiten esta instalación en base mínima.

1.  *Simplicidad*. Arch Linux define simplicidad como sin adiciones o modificaciones innecesarias. De un modo similar, los archivos de configuración de Arch proporcionados por los desarrolladores contienen cambios limitados relativos a cuestiones específicas de la distribución, como el ajuste de las rutas de los archivos del sistema. No añade características de automatización, tales como activar un servicio simplemente porque se ha instalado el paquete. Los paquetes son únicamente divididos cuando existen ventajas convincentes, como por ejemplo para ahorrar espacio en disco, en particular con casos de generar acumulación de residuos. No se proporcionan oficialmente utilidades de configuración gráficas, animando al usuario a realizar la mayor parte de la configuración del sistema desde un terminal y con un editor de texto.
2.  *Modernidad*. Arch Linux se esfuerza por mantener las últimas versiones estables liberadas de software, siempre y cuando no causen errores del sistema en la medida que pueda evitarse razonablemente. Se basa en un sistema lanzamiento continuo (*rolling-release*). Arch incorpora muchas de las nuevas tecnologías disponibles para los usuarios de GNU/Linux, incluyendo el sistema de inicio systemd, sistemas de archivos modernos, LVM2, software RAID, soporte para udev e initcpio (con mkinitcpio), así como las últimas versiones de kernel disponibles.
3.  *Pragmatismo*. Arch es una distribución pragmática antes que idealista. Los principios aquí solo sirven como directrices útiles. En última instancia, las decisiones de diseño se realizan caso por caso a través de un desarrollo consensuado. Las técnicas de análisis se basan en la evidencia y los debates, no en la política o las opiniones públicas.
4.  *Centrado en el usuario*. Mientras que muchas distribuciones de GNU/Linux intentan ser *fáciles de usar*, Arch Linux siempre ha pretendido y pretende permanecer *centrado en el usuario*. Está dirigida a usuarios competentes en GNU/Linux, o a cualquier persona con una actitud «do-it-yourself» que esté dispuesta a leer la documentación y resolver por sí misma los problemas.
5.  *Versatilidad*. Arch Linux es una distribución de propósito general. Tras la instalación, solo se proporciona un entorno de línea de órdenes: en lugar de ir eliminando paquetes innecesarios y no deseados, se ofrece al usuario la posibilidad de crear un sistema personalizado.

## Guión de instalación de Arch GNU/Linux usando scripts

    pacman -S git
	git clone https://github.com/todoterreno/archscripts.git arch
	cd arch
	sh root.sh

## Guión manual de instalación base de Arch GNU/Linux

	loadkeys es
	
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

	wifi-menu
	
	ping 8.8.8.8
	pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
	genfstab -U -p /mnt >> /mnt/etc/fstab
	arch-chroot /mnt

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

### Configuración inicial root

	systemctl start NetworkManager.service
	systemctl enable NetworkManager.service
	
	useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash nombre-de-usuario
	passwd nombre-de-usuario
	nano /etc/sudoers
	reboot

### Configuración inicial user

	sudo nmcli dev wifi connect SSID password PASSWORD
	sudo pacman -Syu

