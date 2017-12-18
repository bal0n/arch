#!/bin/bash

# Variables
ssid=SSID
pass=ABC123
con=false 

while [ $con = false ]; do

    # Conexión
    nmcli dev wifi connect $ssid password $pass

    # Comprobación de conexión
    if ping -c1 google.com &> /dev/null; then
	echo OK;
	con=true;
    else
	echo No conexion;
    fi
done
