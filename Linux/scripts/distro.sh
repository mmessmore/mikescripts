#!/bin/bash

# attempt to determine distro flavor
# start with using lsb_release and fall back to looking at files

if command -v lsb_release >/dev/null 2>&1; then
	out=$(lsb_release -i| sed 's/^.*:\s//')
	case $out in
		# Raspbian pretends it's a distro
		Raspbian)
			echo Debian
			;;
		*)
			echo "$out"
			;;
	esac
elif [ -f /etc/redhat-release ]; then
	echo RedHat
elif [ -f /etc/debian_version ]; then
	echo Debian
elif [ -f /etc/arch-release ]; then
	echo Arch
fi
