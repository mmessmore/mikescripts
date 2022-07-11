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

    This is just a friendly front-end to poudriere so I don't have to remember
    a ton of options.

    2 special commands exist:
        \`update' updates the ports tree
        \`update-release' updates the version of FreeBSD in the jail

    Otherwise it just runs \`poudriere' CMD with the options for the command
    set based on the config at the top of this script.

ARGUMENTS
    CMD     poudriere subcommand (see poudriere(8))
    ARGS    optional arguments to append

OPTIONS
    -h      This help message

EXAMPLES

    $ ${prog} bulk
    $ ${prog} update
    $ ${prog} options text/vim

ISSUES
    It probably doesn't handle all the cases, but just the ones I use.
    (\`jail', \`options', and \`bulk').

    I should externalize the config vs. having it buried in this script.
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

case "$CMD" in
    update)
        exec poudriere ports \
            -u \
            -p "$TREE"
        ;;
    update-release)
        exec poudriere jail \
            -j "$JAIL" \
            -u \
            -J 6 \
            "$@"
        ;;

    jail)
        exec poudriere "$CMD" \
            -j "$JAIL" \
            "$@"
        ;;
    *)
        # otherwise use the pkglist
        exec poudriere "$CMD" \
            -j "$JAIL" \
            -p "$TREE" \
            -z "$SET" \
            -f "$PKG_LIST" \
            "$@"
        ;;
esac
