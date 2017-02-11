#!/bin/bash

###############################################
# Author : ez
# Created Date : 2017/2/10
# 
# Change file and directory permission mask
# to default mask within `umask`, depending
# on your system configuration.
###############################################


# Global variable.
FMASK=$[0666-`umask`]
DMASK=$[0777-`umask`]

FMASK=`echo "obase=8; ibase=10; $FMASK" | bc`
DMASK=`echo "obase=8; ibase=10; $DMASK" | bc`

SILENT_MODE=0
FNUM=0

function _version() {
	VERSION=1.0.2
	echo "Version $VERSION, 2017/2/11"
}

function _help() {
	echo "Usage: "
	echo "	./mask_repair.sh [ operations ... ] dir_name1|file_name1 [ dir_name2|file_name2 ... ]"
	echo "Operation:"
	echo "	-s    With no output."
	_version
	exit 1
}

# Iterate directory (Folder).
function _todir() {
	if [ -d "$1" ]; then
		d="$1"
		[ $SILENT_MODE -eq 1 ] || echo "chmod $d"
		chmod $DMASK "$d"
		((FNUM ++))
		for f in "$d"/*; do
			if [ -d "$f" ]; then
				_todir "$f"
				((FNUM ++))
			elif [ -f "$f" ]; then
				[ $SILENT_MODE -eq 1 ] || echo "chmod $f"
				chmod $FMASK "$f"
				((FNUM ++))
			fi
		done
	fi
}

# Handle options.
function _opt_handle() {
	case $1 in
		"s")
			SILENT_MODE=1
		;;
			*) echo "Error option $1."
		;;
	esac
}

# start.
for file in "$@"; do
	if [ -d "$file" ]; then
		_todir "$file"
	elif [ -f "$file" ]; then
		[ $SILENT_MODE -eq 1 ] || echo "chmod $file"
		chmod $FMASK "$file"
		((FNUM ++))
	elif [[ "$file" =~ -[a-zA-Z] ]]; then
		# Options
		opt=`echo "$file" | sed 's/-\([a-z|A-Z]\)/\1/'`
		_opt_handle $opt
	fi
done

# echo $FNUM
[ $FNUM -lt 1 ] && _help

