#!/bin/bash

function install_driver {
	make -j $1
	STATUS=$?

	if [ $STATUS -ne 0 ]; then
		error $STATUS
	else
		sudo make install -j $1
		dkms_add
	fi
}

# Adds the driver to dkms so that the kernel will include it in future upgrades
function dkms_add {
	if [ -n "$(pacman -Q dkms)" ]; then
		read -p "Add $(pkgname)-$(pkgver) to dkms for including this driver in future kernel upgrades? [Y/n] " yn
		case $yn in
			[Y/y]* ) ;;
			[N/n]* ) exit;;
			* ) ;;
		esac
	else
		read -p "Install dkms for reloading this driver into the kernel upon updating? [Y/n] " yn
		case $yn in
			[Y/y]* ) pacman -S dkms;;
			[N/n]* ) exit;;
			* ) exit;;
		esac
	fi

	echo "Adding ${pkgdir}-${pkgver} to dkms module list"
	mv "$pkgdir/*" $pkgdir/usr/src/${pkgname}-${pkgver}
	dkms install ${pkgname}-${pkgver}
}

function error_deps {
	echo -e "\033[0;31merror: linux-headers not found\033[0m"
	read -p "Install 'linux-headers'? [Y/n] " yn
	case $yn in
		[Y/y]* ) sudo pacman -S linux-headers; install_driver;;
		[N/n]* ) exit 2;;
		* ) sudo pacman -S linux-headers; install_driver;;
	esac
}

function error_reboot {
	echo "\033[0;31merror: kernel version mismatch\033[0m"
	echo "The current version of the kernel doesn't match the installed version"
	echo "You must to reboot before installing ${pkgname}-${pkgver}"
	read -p "Reboot now? [Y/n] " yn
	# TODO: Add this script to systemd and run it on boot to install the driver, then delete the script
	case $yn in
		[Y/y]* ) sudo reboot;;
		[N/n]* ) exit 2;;
		* ) exit 2;;
	esac
}


function error {
	if [ $1 -eq 2 ]; then
		if [[ -n "$(pacman -Q linux-headers)" ]]; then
			error_deps
		else
			error_reboot
		fi
	fi
}

trap exit INT

CORES=$(lscpu | awk '/^Core/{ print $4 }')

install_driver $CORES
