#!/bin/bash
#script:		psbzip.sh
#author:		anon
#date:			15.03.2024
#modification:	15.03.2024
#purpose:
#usage:			./psbzip.sh <script_name>

#exit codes:
#	0	successful exit

list_parts() {
	list=$(ls -l | awk 'NR>=2{print $NF}')
	for i in $list; do
		py7zr x "$i"
	done

	# list=$(ls -l | awk 'NR>=2{print $NF}' | awk -F '[_.]' '{print $(NF-1)"."$NF}')
}

# list_parts() {
# 	list=$(ls -l | awk 'NR>=2{print $NF}')
# 	counter=1
# 	for i in $list; do
# 		cp "$i" "$i".00$counter
# 		let counter++
# 	done
#
# 	# list=$(ls -l | awk 'NR>=2{print $NF}' | awk -F '[_.]' '{print $(NF-1)"."$NF}')
# }

main() {
	list_parts
}

main #$1

exit 0
