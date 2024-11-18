#!/bin/bash
# setsetup.sh

wkd=$(pwd)

setup() {
	if [[ $wkd == $(pwd) ]]; then
		rm -r * 2>/dev/null
		ll
	else
		echo
		echo "⛔$(tput setaf 1) setup() is initialsed for: ${wkd}$(tput sgr 0)"
		echo
	fi
}

echo
echo "$(tput setaf 2)setup() initialised for: ${wkd}$(tput sgr 0)"
echo
