#!/bin/bash
#script:		myvisudo.sh
#author:		anon
#date:			27.01.2024
#modification:	27.01.2024
#purpose:		alternative method to sudo visudo.
#			It should not be used per se.
#			It could serve as basis for other script, notably the modify_etc_sudoers function
#usage:			./myvisudo.sh

#exit codes:
#	0	successful exit
#	1	incorrect usage

usage() {
	if [ $# -gt 0 ]; then
		echo "Usage: $0 <arg>"
		exit 1
	fi
}

intro() {
	tput setaf 3
	cat <<eof

You're about to modify /etc/sudoers, so be cautious.

Normally, visudo prevents you to write anything stupid, but one 🐦 in the hand is better than two in the 🌳

You'll be prompted to enter the command you want to append the sudoers.

This script will also add a commented (#) timestamp 🕓 before any input.
$(tput sgr 0)
EXAMPLES:
Enter input: Defaults\teditor="/snap/bin/nvim"
	# 20240127 17:01:06
	Defaults	editor="/snap/bin/nvim"

Enter input: # set nvim as default editor\nDefaults\teditor="/snap/bin/nvim"
	# 20240127 17:02:33
	# set nvim as default editor
	Defaults	editor="/snap/bin/nvim"

If you enter something bad 😈, you will see the <What now?> message.
You don't need to do anything and nothing will be written to /etc/sudoers.
In the next example, there is a typo. Indeed, it lacks the final [s] in "Defaults".

Enter input: Default\teditor="/snap/bin/nvim"$(
		tput setaf 1
		tput bold
	)
		    ^$(tput sgr 0)
	# 20240127 17:14:24
	Default	editor="/snap/bin/nvim"
	What now?
TIPS:
Do not wrap the command with quotes.
Quotes can be used inside the command though (see above).
You can pass multiple commands by separating them with \n.

\t	insert tab
\n	insert newline
$(tput setaf 5)
Press any key to continue 🤞

eof
	tput sgr 0

	read n
}

user_input() {
	read -erp "Enter input: " input
}

test_input() {
	verifile=/tmp/verifile.txt
	echo -e "$input" >$verifile
	status=$(sudo visudo -c $verifile | awk '{print tolower($NF)}')
	if [[ $status != "ok" ]]; then
		echo "Bad input!"
		exit
	else
		echo -e "\nStatus 👍"
	fi
}

modify_etc_sudoers() {
	ts=$(date "+%Y%m%d %H:%M:%S")
	echo -e "\n# $ts" | (sudo EDITOR="tee -a" visudo) 2>>$errLog
	echo -e $input | (sudo EDITOR="tee -a" visudo) 2>>$errLog
}

outro() {
	[ -s $errLog ] && echo -e "\n\n$(tput setaf 1)Something went wrong$(tput sgr 0) 😭\n" || echo -e "\nDone 😎\n"
}

remove_log() {
	rm $errLog 2>/dev/null
}

errLog=/tmp/errLog.log

main() {
	usage $1
	intro
	user_input
	test_input
	# modify_etc_sudoers
	outro
	remove_log
}

main $1

exit 0
