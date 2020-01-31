*Arch GNU/Linux* es una distribución *GNU/Linux* de propósito general con una instalación por defecto que deja un sistema de base mínima. Los scripts aquí alojados permiten esta instalación en base mínima.

1.  *Simplicidad*. Arch Linux define simplicidad como sin adiciones o modificaciones innecesarias. De un modo similar, los archivos de configuración de Arch proporcionados por los desarrolladores contienen cambios limitados relativos a cuestiones específicas de la distribución, como el ajuste de las rutas de los archivos del sistema. No añade características de automatización, tales como activar un servicio simplemente porque se ha instalado el paquete. Los paquetes son únicamente divididos cuando existen ventajas convincentes, como por ejemplo para ahorrar espacio en disco, en particular con casos de generar acumulación de residuos. No se proporcionan oficialmente utilidades de configuración gráficas, animando al usuario a realizar la mayor parte de la configuración del sistema desde un terminal y con un editor de texto.
2.  *Modernidad*. Arch Linux se esfuerza por mantener las últimas versiones estables liberadas de software, siempre y cuando no causen errores del sistema en la medida que pueda evitarse razonablemente. Se basa en un sistema lanzamiento continuo (*rolling-release*). Arch incorpora muchas de las nuevas tecnologías disponibles para los usuarios de GNU/Linux, incluyendo el sistema de inicio systemd, sistemas de archivos modernos, LVM2, software RAID, soporte para udev e initcpio (con mkinitcpio), así como las últimas versiones de kernel disponibles.
3.  *Pragmatismo*. Arch es una distribución pragmática antes que idealista. Los principios aquí solo sirven como directrices útiles. En última instancia, las decisiones de diseño se realizan caso por caso a través de un desarrollo consensuado. Las técnicas de análisis se basan en la evidencia y los debates, no en la política o las opiniones públicas.
4.  *Centrado en el usuario*. Mientras que muchas distribuciones de GNU/Linux intentan ser *fáciles de usar*, Arch Linux siempre ha pretendido y pretende permanecer *centrado en el usuario*. Está dirigida a usuarios competentes en GNU/Linux, o a cualquier persona con una actitud «do-it-yourself» que esté dispuesta a leer la documentación y resolver por sí misma los problemas.
5.  *Versatilidad*. Arch Linux es una distribución de propósito general. Tras la instalación, solo se proporciona un entorno de línea de órdenes: en lugar de ir eliminando paquetes innecesarios y no deseados, se ofrece al usuario la posibilidad de crear un sistema personalizado.

### Arquitectura del procesador
El primer paso para la realización de la instalación del sistema Arch Linux es conocer la arquitectura del procesador del equipo físico. Arch Linux abandonó el desarrollo para la arquitectura de 32Bits en 2017, por lo tanto ya no se brinda soporte a este tipo de arquitecturas.

Para averiguar con qué arquitectura cuenta nuestro PC:

	uname -m

Para obtener información más detallada sobre el procesador:

	lscpu

### BIOS
La BIOS, creado en 1975, y sus siglas significan Basic Input Output System o sistema básico de entrada y salida. Su función principal es la de iniciar los componentes de hardware y lanzar el sistema operativo de un ordenador cuando este es encendido. También carga las funciones de gestión de energía y temperatura del ordenador.

Al encender el equipo lo primero que se carga en él es la BIOS. Este firmware entonces se encarga de iniciar, configurar y comprobar que se encuentre en buen estado el hardware, incluyendo la memoria RAM, los discos duros, la placa base o la tarjeta gráfica. Cuando termina selecciona el dispositivo de arranque (disco duro, CD, USB etcétera) y procede a iniciar el sistema operativo, y le cede a él el control.

### UEFI
La Interfaz de Firmware Extensible Unificada o UEFI (Unified Extensible Firmware Interface) es el firmware sucesor del BIOS. A mediados de la década pasada las empresas tecnológicas se dieron cuenta de que el BIOS estaba quedándose obsoleto, y 140 de ellas se unieron en la fundación UEFI para renovarla y reemplazarla por un sistema más moderno.

En esencia, todo lo que hemos dicho antes que hace el BIOS lo hace también la UEFI. Pero también tiene otras funciones adicionales y mejoras sustanciales, como una interfaz gráfica mucho más moderna, un sistema de inicio seguro, una mayor velocidad de arranque o el soporte para discos duros de más de 2 TB.

### BIOS y UEFI con respecto al sistema operativo de Arch
Podemos encontrar varias diferencias entre BIOS Y UEFI, pero las que nos importa para entender la instalación de Archlinux son:

* Los sistemas con BIOS utilizan el esquema de particiones MBR, estos sólo soportan hasta cuatro particiones primarias y unidades de almacenamiento de una capacidad máxima de 2,2 TB.
* Los firmware UEFI, por su parte, utiliza el esquema de particiones MBR y GPT. Este ultimo es más moderno poniendo el límite teórico de capacidades de discos duros sopoertadas en 9,4 zettabytes, aunque de momento no se fabrica ninguno tan grande. Pero la caracteristica que si podría interesarnos es la de soportar hasta 128 particiones primarias.

## Guión de instalación de Arch GNU/Linux usando scripts

	SERVER=github.com
	USER=metaphysys
	REPO=archscripts

        pacman -S git
	git clone https://$SERVER/$USER/$REPO.git arch
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
	pacstrap /mnt linux linux-firmware base base-devel networkmanager xf86-input-synaptics
	genfstab -U -p /mnt >> /mnt/etc/fstab
	arch-chroot /mnt

	echo “nombre-de-equipo” >> /etc/hostname
	ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
	echo “LANG=es_ES.UTF-8” >> /etc/locale.conf
	pacman -S nano grub
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

