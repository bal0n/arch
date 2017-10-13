#!/bin/bash

# Variables
nombreusuario=javier

systemctl start NetworkManager
systemctl enable NetworkManager
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $nombreusuario
passwd $nombreusuario
nano /etc/sudoers
exit
