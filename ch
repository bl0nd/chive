#!/usr/bin/env bash

PROG_NAME="ch"
VERSION="0.1.0"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
CONFIG_DIR="${XDG_CONFIG_HOME}/${PROG_NAME}"

# Speed up script by not using unicode.
LC_ALL=C
LANG=C

[[ -d "$CONFIG_DIR" ]] && {
    TEMPLATES="$(find "$CONFIG_DIR" -maxdepth 2 -mindepth 2 -type d ! -path "${CONFIG_DIR}/.git/*" | rev | cut -d/ -f1 | rev)"
}

usage() {
    printf "%s\n" "\
usage: ch [--version] [--help] [--add|-a TARGET ...]
          [--template|-t TARGET|TEMPLATE] [[TARGET ...] TEMPLATE] ...
"
    exit 1
}

add_targets() {
    (( "$#" == 1 )) && {
        printf '%s\n' "error: no targets specified" 1>&2
        exit 1
    }

    shift
    IFS=' ' read -r -a targets <<< $*

    for target in "${targets[@]}"; do
        if [[ ! $target =~ ^[[:alnum:]](.*) ]]; then
            printf '%s\n' "error: \"$target\" does not start with a letter/number" 1>&2
            exit 1
        elif [[ ! $target =~ ^([[:alnum:]]+[_-]*)*$ ]]; then
            printf '%s\n' "error: targets may only contain letters, numbers, \"_\", or \"-\"" 1>&2
            exit 1
        elif grep -m 1 -q ^"$target"$ <<< "$TEMPLATES"; then
            printf '%s\n' "error: \"${target}\" is a template name" 1>&2
            exit 1
        fi

        mkdir -p "${CONFIG_DIR}/${target}"
    done

    (cd "$CONFIG_DIR" && exa -1 -D . 2>/dev/null | GREP_COLORS='cx=1;34' grep --color -E "^$(tr ' ' '|' <<< $*)$" -A100 -B100)
}

list_templates() {
    if (( "$#" == 0 )); then
        (cd "$CONFIG_DIR" && exa -T -L 1 -D -- * 2>/dev/null)
    else
        for target in "$@"; do
            [[ ! "$(exa -L 1 -D "$CONFIG_DIR")" =~ $target ]] && {
                printf '%s\n' "error: unknown target \"$target\"" 1>&2
                exit 1
            }
        done

        (cd "$CONFIG_DIR" && exa -T -L 1 -D -- "$@" 2>/dev/null)
    fi
}

main() {
    [[ ! -d "$CONFIG_DIR" ]] && {
        mkdir -p "${XDG_CONFIG_HOME}/${PROG_NAME}"
    }

    while [[ "$1" ]]; do
        case $1 in
            "--version")
                printf '%s\n' "$PROG_NAME $VERSION"
                exit 1
            ;;
            "--help") usage ;;

            "--add" | "-a")
                add_targets "$@"
                exit
            ;;

            "--template" | "-t")
                #add_templates "$@"
                exit
            ;;

            *)
                break
            ;;
        esac

        shift
    done

    list_templates "$@"
}

main "$@"
