#!/bin/bash -x


# https://wiki.ubuntu.com/UEFI/SecureBoot/Signing
# shows Ubuntu 18.04.1 default location of MOK.{priv,der}
# kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der vmmon.ko


# VMware Workstation 14-15
# /usr/src/linux-headers-$(uname -r)/scripts/sign-file $(modinfo -n vmmon)
# /usr/src/linux-headers-$(uname -r)/scripts/sign-file $(modinfo -n vmnet)
for filename in vmmon vmnet; do
	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $(modinfo -n $filename)
	echo "$filename"
done
sudo service vmware start


# NVIDIA drivers
# https://gist.github.com/Garoe/74a0040f50ae7987885a0bebe5eda1aa
for filename in /lib/modules/$(uname -r)/updates/dkms/*.ko; do
	# sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/.ssl/MOK.priv ~/.ssl/MOK.der $filename
	sudo kmodsign sha512 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der  $filename
	echo "$filename"
done
