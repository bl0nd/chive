#!/usr/bin/env bash

PROG_NAME="ch"
VERSION="0.1.0"
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
CONFIG_DIR="${XDG_CONFIG_HOME}/${PROG_NAME}"

# Speed up script by not using unicode.
LC_ALL=C
LANG=C

usage() {
	printf "%s\n" "\
usage: ch [--version] [--help] [--add|-a TARGET ...]
          [--template|-t TARGET|TEMPLATE] [[TARGET ...] TEMPLATE] ...
"
	exit 1
}

add_targets() {
	(( "$#" == 1 )) && {
		printf '%s\n' 'ch: no targets specified' 1>&2
		exit 1
	}

	shift
	IFS=' ' read -r -a targets <<< $*

	for target in "${targets[@]}"; do
		if [[ ! $target =~ ^[[:alnum:]](.*) ]]; then
			printf '%s\n' 'ch: targets must start with a letter or number' 1>&2
			exit 1
		elif [[ ! $target =~ ^([[:alnum:]]+[_-]*)*$ ]]; then
			printf '%s\n' 'ch: targets may only contain letters, numbers, "_", or "-"' 1>&2
			exit 1
		fi

		mkdir -p "${CONFIG_DIR}/${target}"
	done
}

get_args() {
    while [[ "$1" ]]; do
        case $1 in
			"--version")
				printf '%s\n' "$PROG_NAME $VERSION"
				exit 1
			;;
            "--help") usage ;;

            "--add" | "-a")
				add_targets "$@"
				break
			;;

            "--template" | "-t")
			;;
		esac

		shift
	done
}

main() {
	[[ ! -d "$CONFIG_DIR" ]] && {
		mkdir -p "${XDG_CONFIG_HOME}/${PROG_NAME}"
	}

	get_args "$@"
}

main "$@"
