#!/bin/bash

# Variables
ssid=
pass=

function wifi {
  sudo nmcli dev wifi connect $ssid password $pass
  sudo pacman -Syu
}

  # Instalando VirtualBox
  echo "[*] Instalando paquetes necesarios"
	sudo pacman -S virtualbox qt4 linux-headers
	echo "[OK] Paquetes necesarios instalados"
	echo "[*] Instalando los modulos en el kernel"
	sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci
	echo "[OK] Modulos instalados en el kernel"
	echo "[END] Iniciando virtualbox"


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
