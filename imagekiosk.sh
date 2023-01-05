#!/bin/bash

prog=${0##*/}

usage() {
  cat <<EOM

${prog}

A tool to watch a directory and display images there full screen

USAGE
  ${prog} [DIRECTORY]
  ${prog} -h

OPTIONS
  -h        This help message

ARGUMENTS
  DIRECTORY  Directory to watch (assumed PWD)
EOM
}

preflight() {
  if ! command -v fswatch >/dev/null; then
    echo "Missing fswatch executable"
    exit 1
  fi
  if [ -z "$(image_prog)" ]; then
    echo "Missing open or feh"
    exit 1
  fi
}

image_prog() {
  if command -v feh >/dev/null; then
    echo feh
  elif command -v open >/dev/null; then
    echo open
  else
    echo ""
  fi
}

is_image() {
  local f="$1"

  [ -f "$f" ] || exit 1

  if file "$f" | grep -E '(GIF|TIFF|JPEG|PNG)' >/dev/null 2>&1; then
    return 0
  else
    echo "${f} is not an image"
    return 1
  fi
}

open_image() {
  local f="$1"
  $(image_prog) "$f" &
  echo "$!"
}

while getopts h OPT; do
  case "$OPT" in
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 22
      ;;
  esac
done

shift $((OPTIND - 1))

DIRECTORY="$1"
[ -z "$DIRECTORY" ] && DIRECTORY=.

preflight

fswatch -0 \
  --event Created \
  --event Updated \
  --event MovedTo \
  --event IsFile \
  --event IsSymLink \
  "$DIRECTORY" | 
  while read -r -d $'\0' fp; do
    [ "$old_file" = "$fp" ] && continue
    old_file="$fp"
    [ -z "$i" ] && i=0
    echo "checking ${fp}"
    is_image "$fp" || continue

    [ -n "$pid" ] && kill "$pid"
    pid=$(open_image "$fp")
    ((i++))

    [ "$i" -gt "10" ] && exit 1
  done
