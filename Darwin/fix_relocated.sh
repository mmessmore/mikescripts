#!/bin/bash

# This moves reloacted files from a MacOS upgrade back to where they belong

prog="${0##*/}"

usage() {
	cat <<EOM
${prog} USAGE
	${prog}
	${prog} -h

${prog} moves reloacted files from a MacOS upgrade back to where they belong.
It will sudo itself if necessary.

OPTIONS
	-h		This handy usage message
EOM
}

bail() {
	local retval
	local message

	retval="$1"
	shift
	message="$*"

	echo "Error: ${message}" >&2
	exit "$retval"
}

while getopts h OPT; do
	case "$OPT" in
		h)
			usage
			exit 0
			;;
		*)
			bail 22 "Invalid option ${OPT}"
			;;
	esac
done

shift $(( OPTIND - 1 ))


if [ "$(id -u)" != "0" ]; then
	exec sudo "$0" "$@"
fi



base_dir=~/Desktop/Relocated\ Items.nosync/Configuration

[ -d "${base_dir}" ] || bail 1 "No relocated files to deal with. Exiting"

find "$base_dir" -type f |
	while read -r f; do
		if [[ ${f##*/} == .* ]]; then
			echo "${f} is a hidden file, ignoring"
			continue
		fi

		path=${f#$base_dir}
		mv -fv "$f" "$path" ||
			bail $? "Couldn't move file ${f} to ${path}"
	done

echo "Cleaning up Desktop symlink"
rm -f ~/Desktop/Relocated\ Items.nosync

exit 0
