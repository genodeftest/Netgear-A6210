# Netgear-A6210
This driver supports Ralink / Mediatek mt766u, mt7632u and mt7612u chipsets.

In particular, the driver supports several USB dongles such as Netgear-A6210,
ASUS USB-AC55, ASUS USB-N53 and EDUP EP-AC1601.

Linux kernel version up to 4.18 has been tested.

To build the driver, follow these steps:

	$ git clone https://gitlab.com/nagefire/netgear-a6210.git
	$ cd netgear-a6210
	$ make
	$ sudo make install

The driver is mostly tested on 64 bit Ubuntu 15.10 and Debian 8.3 with NETGEAR AC1200
High Gain Wifi USB Adapter. Some other distro/dongle combinations work as well, for
example Linux Mint 17.3 "Rosa" - KDE (32-bit)/ASUS USB-N53 seems to work flawlessly
(as reported by Roland Bauer). I have tested it for kernel 4.18.4 with Arch Linux
x86_64 and arch linux ARMv7 (rasberry pi).

The supported chipsets can be present in other devices. To include additional
devices, you need to add corresponding VendorID, DeviceID into the file
"rtusb_dev_id.c"

The original code was downloaded from: 
http://cdn-cw.mediatek.com/Downloads/linux/MT7612U_DPO_LinuxSTA_3.0.0.1_20140718.tar.bz2

The driver provided at this link NO LONGER COMPILES, so do not attempt to use it. I
do not plan on maintaining this driver, but rather keeping it up to date with
it's branch at:
https://github.com/kaduke/Netgear-A6210

and maintaining it as a PACKAGE for the AUR. I may add functions and edit or reformat
files as I see fit, such as the creating the install script, and I may even attempt
adding it as a package for other distros.

This is work in progress. The driver is functional, however, there are still several
issues that need to be addressed, such as the driver providing extraneous output
(for debugging purposes) to the kernel logs. Also, hot-unplugging may cause the
network manager to become unreliable. After plugging the dongle back in, you may need
to restart the manager:

	$ sudo service network-manager restart
			or
	$ sudo netctl restart <profile>

This seems to be Linux distro dependent, but has definitely been observed on Ubuntu,
I have not yet had any problems with the driver on Arch.

At present, there is no LED support yet (Netgear-A6210 does not have
any LEDs, but other dongles do, such as the A).

EDUP EP-AC1601 works (or to be precise, should work), but at present there are
several problems such as frequent dropping of connection, failure to connect, wildly
oscillating signal strength etc. This "feature" also seems to depend on the Linux distro,
probably as a result of differing kernels, so please use the most up-to-date
installation provided.

## DKMS Install

On Debian-based distros, you can add the module to DKMS so it will automatically
build and install on each successive kernel upgrade. To do this, issue the following
commands from within the repo's folder:

	$ cd ..
	$ sudo mv Netgear-A6210/ /usr/src/netgear-a6210-2.5.0
	$ sudo dkms install netgear-a6210/2.5.0

To remove:

	$ sudo dkms remove netgear-a6210/2.5.0 --all
