#!/bin/bash
#script:		sysinstaller.sh
#author:		anon
#date:			19.01.2024
#mod.:			19.01.2024
#purpose:		automate installation process of new system
#notes:			for a vm, first install guest additions tools
#usage:			./sysinstaller.sh

#exit codes:
#	0	successful exit
#	1	incorrect usage

usage() {
	if [ $# -gt 0 ]; then
		echo "Usage: $0 <arg>"
		exit 1
	fi
}

log() {
	echo "LOG: $1" >>$errLog
}

timerStart() {
	start_time=$(date +%s)
}

timerStop() {
	elapsed_time=$(($(date +%s) - $start_time))
	seconds=$(($elapsed_time % 60))
	minutes=$((($elapsed_time % 3600) / 60))
	hours=$((($elapsed_time % 86400) / 3600))

	printf "$(tput setaf 6)%s: %02d:%02d:%02d$(tput sgr 0)\n\n" "Elapsed time"
	$hours $minutes $seconds
}

force_sudo_mode() {
	trap "exit" INT TERM
	trap "kill 0" EXIT
	sudo -vB || exit $?
	sleep 1
	while true; do
		sleep 60
		sudo -nv
	done 2>/dev/null &
}

modify_bashrc() {
	log "modify ~/.bashrc"
	echo "alias up2date=\"sudo nala update && sudo nala upgrade -y\"" >>~/.bashrc
	echo "alias nv=\"nvim\"" >>~/.bashrc
	echo "alias updatekitty=\"curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin\"" >>~/.bashrc
	echo "alias cmx=\"cmatrix -C green -a\"" >>~/.bashrc
	echo "alias icat=\"kitty +kitten icat\"" >>~/.bashrc
	echo "export PATH=\"$HOME/Documents/executables:$PATH\"" >>~/.bashrc
	echo "sudovisudo(){ sudo EDITOR=\"/snap/bin/nvim\" visudo; }" >>~/.bashrc

	source ~/.bashrc
}

install_nala_and_first_up2date() {
	log "install nala"
	sudo -v
	sudo apt install nala -y
	sudo nala update && sudo nala upgrade -y
}

sumup() {
	docker ps

	printf "$(tput setaf 4)\n\n%s\n\n$(tput sgr 0)" "Done:-)"
	[ -f $errLog ] && cat $errLog || echo "No error logged."

	tput setaf 1
	tput bel
	cat <<EOF

Second step over.

EOF
	tput sgr 0
}

errLog=/tmp/errors.log

main() {
	usage
	timerStart
	force_sudo_mode
	modify_bashrc
	install_nala_and_first_up2date

}

main #$1

exit 0
