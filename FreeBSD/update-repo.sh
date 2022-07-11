#!/usr/bin/env bash


#defaults
MINS=720
UPDATE_LIST=true
PKG_FILE=/usr/local/etc/poudriere.d/13amd64-local-workstation-pkglist
VERBOSE=false

prog="${0##*/}"

usage() {
    cat <<EOM

${prog} USAGE

    ${prog} [-Nv] [-n MINS] [-P FILE]
    ${prog} -h

    This updates the ports tree makes sure options are set and bulk builds
    changed ports

${prog} OPTIONS

    -h          This friendly help message
    -n MINS     Minimum number of mins between portsnaps (default ${MINS})
                \`poudriere options' will also only be run if updated
    -N          Don't update list of ports based on installed software
    -P FILE     Specify pkglist
                (default ${PKG_FILE})

EOM
}

update_list() {
    tmpfile=$(mktemp "/tmp/${prog}.XXXXXX")
#    trap 'rm -fr "$tmpfile"' EXIT
    {
        cat "$PKG_FILE"
        # this only selects pkgs that were installed and not dependencies
        pkg query -e "%a = 0" "%o"
    }| sort -u > "$tmpfile"

    if diff "$PKG_FILE" "$tmpfile" >/dev/null 2>&1; then
        echo "${prog}: No changes to pkglist"
    else
        echo "${prog}: pkglist not up to date, fixing that"
        if ! cat "$tmpfile" > "$PKG_FILE"; then
            retval=$?
            echo "${prog}: Error updating pkglist" >&2
            return "$retval"
        fi
    fi
}

while getopts hn:Nv OPT; do
    case "$OPT" in
        h)
            usage
            exit 0
            ;;
        n)
            MINS="$OPTARG"
            ;;
        N)
            UPDATE_LIST=false
            ;;
        v)
            VERBOSE=true
            ;;
        *)
            echo "Unknown option: $OPT" >&2
            usage
            exit 22
            ;;
    esac
done


# root ourself
[ "$(id -u)" = "0" ] || exec sudo "$0" "$@"

# die on error
set -e

# spit out everything if VERBOSE
"$VERBOSE" && set -x


if "$UPDATE_LIST"; then
    echo "${prog}: Updating pkglist"
    update_list
else
    echo "${prog}: Skipping pkglist update"
fi

if find /usr/ports/.portsnap.INDEX -mmin "+${MINS}" |
    grep -q . >/dev/null 2>&1; then
    echo "${prog}: portsnap older than ${MINS} mins.  Updating"
    portsnap fetch
    portsnap update
    powder options
fi

echo "${prog}: Building.  Fire in the hole!"
echo

powder bulk
