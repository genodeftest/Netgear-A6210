#!/bin/bash

if [ "$(id-u)" != "0" ]; then
	echo "This script requires root access"
	exit 1
fi
function install {
	make
	make install
	dkms_add()
}

# Adds the driver to dkms so that th kernel will include it in future upgrades
function dkms_add
{
	if [[ -n $(pacman -Q dkms)]]; then
		read -p "Add $(pkgname)-$(pkgver) to dkms for including this driver in future kernel upgrades? [Y/n]" yn
		case $yn in
			[Y/y]* );;
			[Nn]* ) exit;;
			* ) dkms_add();;
		esac
	else
		read -p "Install dkms for reloading this driver into the kernel upon updating? [Y/n]" yn
		case $yn in
			[Y/y]* ) pacman -S dkms;;
			[N/n]* ) exit;;
			* ) pacman -S dkms;;
		esac
	fi
	
	mv "$pkgdir/*" $pkgdir/usr/src/${pkgname}-${pkgver}
	dkms install ${pkgname}-${pkgver}
}
