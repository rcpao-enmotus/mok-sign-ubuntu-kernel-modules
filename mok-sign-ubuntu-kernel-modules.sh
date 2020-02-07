#!/bin/bash -x


# UEFI (BIOS) Setup Warning:
# MSI X470 Gaming M7 AC: Just running the M-Flash utility will Restore
#   Defaults, erasing all UEFI Secure Boot keys (including all MOKs)!


# https://wiki.ubuntu.com/UEFI/SecureBoot/Signing
# shows Ubuntu 18.04.1 default location of MOK.{priv,der}
# kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der vmmon.ko


# https://wiki.ubuntu.com/UEFI/SecureBoot/DKMS
# sudo mokutil --import /var/lib/shim-signed/mok/MOK.der
#   ... will ask you for a one-time transport password which you must
#   re-enter after reboot in the blue screen MOK enrollment program.
#   You will never need this particular transport password again.


# https://askubuntu.com/a/813560/329961
# mokutil --list-enrolled
# mokutil --export # exports MOK-####.der files to current directory
# sudo mokutil --delete MOK-0002.der


# VMware Workstation 14-15
# /usr/src/linux-headers-$(uname -r)/scripts/sign-file $(modinfo -n vmmon)
# /usr/src/linux-headers-$(uname -r)/scripts/sign-file $(modinfo -n vmnet)
# for filename in vmmon vmnet; do
# 	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $(modinfo -n $filename)
# 	echo "$filename"
# done
# sudo service vmware restart


# VirtualBox 6.0
# /usr/src/linux-headers-$(uname -r)/scripts/sign-file $(modinfo -n vboxdrv)
# for filename in vboxdrv; do
# 	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $(modinfo -n $filename)
# 	echo "$filename"
# done
# sudo modprobe vboxdrv
# sudo service virtualbox restart


for filename in /lib/modules/$(uname -r)/misc/*.ko; do
	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $filename
	echo "$filename"
done
sudo service vmware restart
#sudo modprobe vboxdrv
sudo service virtualbox restart


# NVIDIA drivers
# https://gist.github.com/Garoe/74a0040f50ae7987885a0bebe5eda1aa
for filename in /lib/modules/$(uname -r)/updates/dkms/*.ko; do
	# sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/.ssl/MOK.priv ~/.ssl/MOK.der $filename
	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $filename
	echo "$filename"
done
