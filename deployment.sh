#!/bin/bash

target=target

createRoute () {
	mkdir -p $2
	cp $1 $2
	echo $2 ok
}

sudoCreateRoute () {
	sudo mkdir -p $2
	sudo cp $1 $2
	echo $2 ok
}

simpleCp () {
	cp $1 $2
	echo $2 ok
}

createRoute $target/termite/config ~/.config/termite 
simpleCp $target/.bashrc ~/.bashrc 
simpleCp $target/.xinitrc ~/.xinitrc 
simpleCp $target/.xbindkeysrc ~/.xbindkeysrc 
sudoCreateRoute $target/10-keyboard.conf /etc/X11/xorg.conf.d 
sudoCreateRoute $target/50-synaptics.conf /etc/X11/xorg.conf.d 
sudoCreateRoute $target/50-mouse-acceleration.conf /etc/X11/xorg.conf.d 
sudoCreateRoute $target/50-mouse-deceleration.conf /etc/X11/xorg.conf.d 

