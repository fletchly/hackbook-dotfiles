#!/bin/bash
seconds=5

while getopts "c:" opt; do
    case $opt in
        c) seconds="$OPTARG" ;;
        *) echo "Usage: $0 -c <seconds>"; exit 1 ;;
    esac
done

countdown_then_run() {
    local cmd="$1"
    local yellow="\033[33m"
    local gray="\033[90m"
    local reset="\033[0m"

    for ((i=seconds; i>0; i--)); do
        printf "\rLogging out in ${yellow}%d${reset} seconds...\n${gray}press any key to cancel, enter to skip${reset}" "$i"
        if read -r -s -n 1 -t 1 key; then
	    if ["$key" == ""] || ["$key" == $'\r' ]; then
		printf "\n"
	        eval "$cmd"
		return
	    fi
            printf "\r                      \033[A\rCancelled.                            \n"
            return 1
        fi
        printf "\033[A"  # move cursor back up for next iteration
    done

    eval "$cmd"
}

countdown_then_run "swaymsg exit"
