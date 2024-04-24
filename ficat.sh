#!/bin/bash
#script:		ficat.sh
#author:		anon
#date:			10.01.2024
#modification:	07.02.2024
#purpose:		displays all images contained within a folder
#usage:			./icat.sh <script_name>

#exit codes:
#	0	successful exit

usage() {
	if [ $# -ne 1 ]; then
		echo "$(tput setaf 1)Incorrect usage!: ficat <path>$(tput sgr 0)"
		exit 1
	fi
}

image_cat() {
	# remove the destination in case of consecutive runs
	rm /tmp/pngs 2>/dev/null

	images=$(ls $1)

	# get the list of every image file
	for i in $images; do
		echo $i >>/tmp/pngs
	done

	# remove the ansi char of ls command
	files=$(ansi2txt </tmp/pngs)

	# print every image and its size
	for i in $files; do
		tput setaf 5
		printf "\n%-25s%s\n" "FILE" "SIZE"
		tput sgr 0
		file $i | awk -F '[:,]' '{printf "%-24s%s\n", $1,$3}'
		kitty +kitten icat $i 2>/dev/null
	done
}

path=$1

main() {
	usage $path
	image_cat $path
}

main $path

exit 0
