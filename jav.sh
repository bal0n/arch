#!/bin/bash

# Variables
ssid=
pass=

function wifi {
  sudo nmcli dev wifi connect $ssid password $pass
  sudo pacman -Syu
}

function xorg {
  sudo pacman -S $(<packages/xorg.txt)
}

function config {
  sudo pacman -S $(<packages/config.txt)
  xdg-user-dirs-update
}

function files {
  git clone https://github.com/franciscodejavier/files.git
  mv files/.nanorc ~/.nanorc
  mv files/.bashrc ~/.bashrc
  mv files/.xbindkeysrc ~/.xbindkeysrc
  mv files/.xinitrc ~/.xinitrc
  sudo mv files/etc/X11/xorg.conf.d/10-keyboard.conf /etc/X11/xorg.conf.d/10-keyboard.conf
  sudo mv files/etc/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
  mkdir ~/.config/termite
  mv files/.config/termite/config ~/.config/termite/config
  sudo rm -R files
}

function awesome {
  sudo pacman -S $(<package/awesome.txt)
}

function tools {
  sudo pacman -S $(<package/tools.txt)
    
  # Instalando VirtualBox
  echo "[*] Instalando paquetes necesarios"
	sudo pacman -S virtualbox qt4 linux-headers
	echo "[OK] Paquetes necesarios instalados"
	echo "[*] Instalando los modulos en el kernel"
	sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci
	echo "[OK] Modulos instalados en el kernel"
	echo "[END] Iniciando virtualbox"
}

function myapplications {
  sudo pacman -S $(<package/apps.txt)
}

function mariadb {
	echo Instalando MariaDB
	sudo pacman -S mariadb
	echo "mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql"
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mysqld
	sudo mysql_secure_installation
	mysql -u root -p
}

# Secuencia
if ping -c1 google.com &> /dev/null; then
	echo OK;
else
	echo No conexion;
	wifi;
fi
xorg
config
files
awesome
tools
myapplications
mariadb
