#!/bin/bash

# Variables
mm=/dev/mmcblk0
mm1=/dev/mmcblk0p1
mm2=/dev/mmcblk0p2
mnt=/mnt
mntboot=/mnt/boot
mntroot=/mnt/root
urlarch=http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

#	For more help
#		https://gist.github.com/theramiyer/cb2b406128e54faa12c37e1a01f7ae15
#
#	1 List out all the drives and partitions using lsblk. Note down the name of the SD card. In my case, it is mmcblk0.
#	2 Start fdisk using sudo fdisk /dev/mmcblk0.
#	3 Delete the existing partitions by entering o at the prompt. This clears out all partitions on the card.
#	4 Type p to list the partitions; there should be none.
#	5 Create a new partition with n, make it primary by entering p, set it as the first partition using 1.
#	6 Press Entermkfs.vfat /dev/mmcblk0p1 to accept the default first sector. At the prompt, enter +110M to make it a 100 MB partition.
#	7 Type t and then c to set the partition type to W95 FAT32 (LBA).
#	8 Now, to create the second partition, type n, then p, make it the second partition by typing 2, and then, press Enter twice to accept the default first and the last sectors.
#	9 Enter w to write this configuration to the card.
#	10 Next, format the first partition as VFAT, and the second as EXT4.
#	
#	Abstract:
#		lsblk
#		sudo fdisk $mm
#		o
#		p
#		n
#		p
#		1
#		#default
#		+100M
#		t
#		c
#		#W95 FAT32 (LBA)
#		n
#		p
#		2
#		#default
#		#default
#		w


# Disk formating and mount
sudo mkfs.vfat $mm1
sudo mkfs.ext4 $mm2

sudo mkdir -p $mnt
sudo mkdir -p $mntboot
sudo mkdir -p $mntroot

sudo mount $mm1 $mntboot
sudo mount $mm2 $mntroot

#wget $urlarch 
sudo tar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C $mntroot

echo Sincronizando. Esto puede tardar unos minutos.
sync

sudo mv $mntroot/boot/* $mntboot
sudo umount $mntboot $mntroot

echo Fin