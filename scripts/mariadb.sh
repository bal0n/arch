#!/bin/bash

function instalacion {
    sudo pacman -Sy --noconfirm mariadb
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo systemctl start mysqld
    sudo mysql_secure_installation

    echo "[!] Instalación de MariaDB completada"
}

function acceso {
    mysql -u root -p    
}

instalacion
#acceso
