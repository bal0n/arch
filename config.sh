#!/bin/bash

# Variables
nombreusuario=javier

systemctl start NetworkManager
systemctl enable NetworkManager
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $nombreusuario
passwd $nombreusuario
nano /etc/sudoers

echo -e "[!] Instalando Yaourt"
echo -e "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf 
sudo pacman -Sy
sudo pacman -S yaourt

exit
