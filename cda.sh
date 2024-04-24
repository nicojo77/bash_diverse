#!/bin/bash
#script:		cda.sh
#author:		anon
#date:			10.02.2024
#modification:	11.02.2024
#purpose:
#usage:			./cda.sh <script_name>

#exit codes:
#	0	successful exit
#	1	incorrect usage
#	2	user selection and quit
#	3	user select quit

usage() {
	if [ $# -gt 0 ]; then
		echo "Usage: $0"
		exit 1
	fi
}

counters() {
	env_list=$(conda env list | awk -F ' ' 'NR>=3{print $1}')
	list_length=$(conda env list | awk -F ' ' 'NR>=3{print NR-3}' | tail -n 1)
	count_quit=$(($list_length + 1))
}

select_environment() {
	counters
	COLUMNS=1

	conda env list

	status=$(conda env list | awk '$2 ~ /*/' | awk -F ' ' '{print $1}')
	echo -e "Current environment: $(tput setaf 2)$status$(tput sgr 0)\n"

	if [[ $status != "base" ]]; then
		echo -e "Selecting an other environment will deactivate $status\n"
	fi

	select env in $env_list "QUIT"; do

		# select
		if [[ $REPLY -le $list_length && $REPLY != '0' ]]; then
			# environment already in use
			if [[ $status != "base" ]]; then
				echo -e """\nNext command copied to clipboard: $(tput setaf 2)
					\r>>> conda deactivate && conda activate $env$(tput sgr 0)\n
					\r$(tput bold)ctrl+shift+v to paste into terminal.$(tput sgr 0)\n"""
				# paste conda command to kitty clipboard
				echo "conda deactivate && conda activate $env" | kitty +kitten clipboard
				exit 2

			# base environment in use
			else
				echo -e """\nNext command copied to clipboard: $(tput setaf 2)
				\r>>> conda activate $env$(tput sgr 0)\n
				\r$(tput bold)ctrl+shift+v to paste into terminal.$(tput sgr 0)\n"""
				# paste conda command to kitty clipboard
				echo "conda activate $env" | kitty +kitten clipboard
				exit 2
			fi

		# quit
		elif [[ $REPLY == $count_quit ]]; then
			exit 3
		fi

	done
}

main() {
	usage
	select_environment
}

main

exit 0
