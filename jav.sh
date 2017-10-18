#!/bin/bash

# Variables
ssid=
pass=

function wifi {
  sudo nmcli dev wifi connect $ssid password $pass
  sudo pacman -Syu
}

function xorg {
  sudo pacman -S xorg-server xorg-xinit mesa mesa-demos xf86-video-intel
}

function config {
  sudo pacman -S git xdg-user-dirs wget ntfs-3g dialog net-tools openssh openvpn file-roller p7zip unrar unzip
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
  sudo pacman -S awesome pulseaudio pulseaudio-alsa pamixer xbindkeys acpi termite unclutter xorg-xbacklight artwiz-fonts ttf-bitstream-vera conky
}

function tools {
  sudo pacman -S htop nethogs nmap gvfs-mtp libmtp android-tools android-udev emacs jre8-openjdk eclipse python ruby lua
}

function myapplications {
  sudo pacman -S firefox firefox-i18n-es-es libreoffice libreoffice-es vlc qt4 eog gimp evince nautilus emacs
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

