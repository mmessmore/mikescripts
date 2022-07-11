#!/usr/bin/env bash

# Bootstrap `chezmoi` from current, because the templating in OS packages
# lags behind

prog=${0##*/}

usage() {
    cat <<EOM

${prog} USAGE

    ${prog} PERSONAL_REPO
    ${prog} -h

    ${prog} makes sure GO is installed, it's setup the way I like,
    builds/installs chezmoi, inits and applies it.

    It sets defaults for GOPATH (~/src/go) unless that environment variable
    is already set.

${prog} OPTIONS

    -h              This handy help message

${prog} ARGUMENTS

    PERSONAL_REPO   git URL for your personal chezmoi git repo
EOM
}

while getopts h OPT; do
    case "$OPT" in
        h)
            usage
            exit 0
            ;;
        *)
            echo "${prog}: Invalid option: ${OPT}" >&2
            usage
            exit 22
            ;;
    esac
done

shift $((OPTIND - 1))

REPO="$1"

if [ -z "$REPO" ]; then
    echo "${prog}: Missing PERSONAL_REPO" >&2
    exit 1
fi

for cmd in go git; do
    if ! command -v "$cmd" >/dev/null; then
        echo "${prog}: ${cmd} is not installed or in PATH, exiting" >&2
        exit 1
    fi
done

GOPATH=${GOPATH:-~/src/go}

set -ex

go install github.com/twpayne/chezmoi@latest

chezmoi init "$REPO"
chezmoi apply
