#!/bin/bash
#script:		geturl.sh
#author:		anon
#date:			18.06.2024
#modification:	18.06.2024
#purpose:
#usage:			./geturl.sh

#exit codes:
#	0	successful exit

main() {
	echo "zeek-cut host uri <http.log | awk -F '\t' '{print\$1"/"\$2}' | sed 's#//#7#g'"
	echo
	zeek-cut host uri <http.log | awk -F '\t' '{print$1"/"$2}' | sed 's#//#/#g'
}

main

exit 0
