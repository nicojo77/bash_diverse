#!/bin/bash
#script:		compareNpcaps.sh
#author:		anon
#date:			19.03.2024
#modification:	19.03.2024
#purpose:
#usage:			./compareNpcaps.sh from the folder you want to check the get_numbers_of_pcaps.

get_numbers_of_pcaps() {
	awk 'BEGIN{printf "%s%55s\n", "PRODUCTS:", "N pcaps:"}'
	list=$(ls -d */)
	for i in $list; do
		nPcaps=$(find $i/. -type f -name "*.pcap" | wc -l)
		printf "%s\t%s\n" $i $nPcaps
	done
}

main() {
	get_numbers_of_pcaps
}

main

exit 0
