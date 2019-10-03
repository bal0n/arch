#!/bin/bash

function instalacion {
    echo "[*] Instalando paquetes necesarios"
    sudo pacman -Sy --noconfirm virtualbox linux-headers

    echo "[*] Instalando los modulos en el kernel"
    sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci
}

function acceso {
    virtualbox
}

instalacion
acceso
