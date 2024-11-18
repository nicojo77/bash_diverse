#!/bin/bash
# https://sw.kovidgoyal.net/kitty/layouts/
# https://sw.kovidgoyal.net/kitty/remote-control/#
# Create next layout into Kitty terminal, ctrl+shift+f2 for config.
#
# ┌──────────────┬───────────────┐
# │              │               │
# │   win1       │               │
# │              │               │
# ├──────────────┤     main      │
# │              │               │
# │   win2       │               │
# │              │               │
# └──────────────┴───────────────┘
#
# The script name should be prefixed by p_, e.g. p_mellon.sh.
# Then create an alias in ~/.bashrc, e.g.:
# alias p_mellon="source /home/anon/Documents/git/bashScripts/diverse/p_mellon.sh"

usage() {
	echo "Usage: $0 opt:[n_windows]"
	sleep 3
	exit 1
}

create_template() {
	# Subject to modification according to project.
	project="mellon"
	cda="conda activate capcap310"

	# Change directory and load project environment manually.
	kitty @ set-tab-title ${project}         # Tab title - appears on upper left-hand side corner.
	kitty @ set-window-title ${project}_main # Window tiltle - appears in top middle.
	cd /home/anon/Documents/git/pythonScripts/${project}/ || exit
	${cda}

	# Create n numbers or at least win1 and 2.
	if [ -z "$1" ]; then
		n=2
	else
		n="$1"
	fi

	for ((i = 1; i <= n; i++)); do
		kitty @ launch --cwd /home/anon/Desktop/TESTS/ --title "${project}_win$i"
		kitty @ send-text --match title:"${project}_win$i" "$cda\n"
		kitty @ send-text --match title:"${project}_win$i" "clear\n"
		# kitty @ set-window-logo --match title:"${project}_win$i" none
	done
	# Put focus on main window.
	kitty @ focus-window
	kitty @ send-text "clear\n"
	# kitty @ send-text --match title:$project\_main "clear\n"
}

main() {
	if [ $# -gt 1 ]; then
		usage
	fi

	if [[ "$#" -eq 1 && ! $1 =~ ^[0-9]+$ ]]; then
		usage
	fi

	create_template $1
}

main $@
