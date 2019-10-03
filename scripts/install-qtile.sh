#!/bin/bash
# More info: https://wiki.archlinux.org/index.php/Qtile
remote=https://gitlab.com/theoslogos/qtile

sudo pacman -S qtile
git clone https://gitlab.com/theoslogos/qtile ~/.config/qtile
#mkdir -p ~/.config/qtile/
#cp /usr/share/doc/qtile/default_config.py ~/.config/qtile/config.py
