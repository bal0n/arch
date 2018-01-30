#!/bin/bash

# Variables
ssid=SSID
pass=ABC123
conexion=false

while [ $conexion = false ]; do
    nmcli dev wifi connect $ssid password $pass
    if ping -c1 google.com &> /dev/null; then
	echo Ok;
	con=true;
    else
	echo No conexion;
	echo "Introduzca SSID: "
	read $ssid
	echo "Password: "
	read $pass
    fi
done
