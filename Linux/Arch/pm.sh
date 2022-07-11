#!/bin/bash

export prog=${0##*/}

usage() {
    cat <<EOM

$prog usage

    $prog COMMAND [ARGUMENTS]
    $prog -h

GLOBAL OPTIONS
    -h          This help message

COMMANDS

    autoremove  Act like \`apt autoremove'
                alias for \`pacman -Rcns \$(pacman -Qdtq)'
    install     Install packages
                alias for \`pacman -S PACKAGEs'
    remove      Uninstall packages
                alias for \`pacman -Rs PACKAGEs'
    search      Search packages ARGUMENT is a pattern
                alias for \`pacman -Ss PATTERN'
    uninstall   Same as remove, because I forget which command uses which
    upgrade     Upgrade specific packages when supplied, otherwise upgrade the
                universe.
                alias for \`pacman -Su PACKAGEs' or \`pacman -Syu'

NOTES
    You probably want to run as root, or have a NOPASSWD rule to run pacman
    or this will be miserable
EOM
}

pm_autoremove() {
    if [ -z "$(pacman -Qdtq)" ]; then
        echo "${prog}: Nothing to clean up"
        exit 0
    fi
    sudo pacman -Qdtq | xargs sudo pacman -Rcns
}

pm_install() {
    sudo pacman -Ss "$@"
}

pm_remove() {
    sudo pacman -Rs "$@"
}

pm_search() {
    sudo pacman -Ss "$@"
}

pm_upgrade() {
    if [ -n "$1" ]; then
        sudo pacman -Su "$@"
    else
        sudo pacman -Syu
    fi
}

COMMAND="$1"
shift

if [ -z "$COMMAND" ]; then
    echo "No command specified" >&2
    usage
    exit 22
fi

case "$COMMAND" in
    -h)
        usage
        exit 0
        ;;
    autoremove)
        pm_autoremove
        ;;
    install)
        pm_install "$@"
        ;;
    remove)
        pm_remove "$@"
        ;;
    search)
        pm_search "$@"
        ;;
    uninstall)
        pm_remove "$@"
        ;;
    upgrade)
        pm_upgrade "$@"
        ;;
    *)
        echo "Unrecognized command: ${COMMAND}" >&2
        usage
        exit 22
esac


