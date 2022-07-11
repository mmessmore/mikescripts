#!/usr/bin/env bash

prog=${0##*/}

# CONFIG
JAIL=13amd64
TREE=local
SET=workstation
PKG_LIST=13amd64-local-workstation-pkglist


usage() {
    cat <<EOM
${prog} USAGE

    ${prog} CMD [ARGS]
    ${prog} -h

This runs the poudriere command with the options for our default setup

ARGUMENTS
    CMD     poudriere subcommand (see poudriere(8))
    ARGS    optional arguments to append

OPTIONS
    -h      This help message

EXAMPLES

    $ ${prog} bulk
    $ ${prog} options text/vim
EOM
}

# root ourself
[ "$(id -u)" = "0" ] || exec sudo "$0" "$@"

# handle basic args
CMD="$1"
shift

# Help!
if [ "$CMD" = "-h" ]; then
    usage
    exit 0
fi

# Missing anything to do
if [ -z "$CMD" ]; then
    echo "Missing required arguments" >&2
    usage
    exit 22
fi

# cd to the config dir or die because I'm lazy
cd /usr/local/etc/poudriere.d/ || exit $?

# let's print commands from here out
set -x

# if a port is specified in the args don't use the pkglist
for arg in "$@"; do
    if [[ "$arg" =~ [[:alnum:]]+/[[:alnum:]] ]]; then
        exec poudriere "$CMD" \
            -j "$JAIL" \
            -p "$TREE" \
            -z "$SET" \
            "$@"
    fi
done

# otherwise use the pkglist
exec poudriere "$CMD" \
    -j "$JAIL" \
    -p "$TREE" \
    -z "$SET" \
    -f "$PKG_LIST" \
    "$@"
