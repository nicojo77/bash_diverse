#!/bin/bash
#script:		ficat.sh
#author:		anon
#date:			10.01.2024
#modification:	10.01.2024
#purpose:		displays all images contained within a folder
#usage:			./icat.sh <script_name>

#exit codes:
#	0	successful exit

usage() {
	if [ $# -ne 1 ]; then
		echo "$(tput setaf 1)Incorrect usage!: $0 <path>$(tput sgr 0)"
		exit 1
	fi
}

image_cat() {
	kitty +kitten icat $1/* 2>/dev/null
}

path=$1

main() {
	usage $path
	image_cat $path
}

main $path

exit 0
