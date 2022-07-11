#!/bin/bash

prog=${0##*/}

# standard erro.h codes we use
EINVAL=22
ENOENT=2

# usage message
usage() {
	cat <<EOM

${prog} USAGE

	${prog} [-t OUTPUT_TYPE] [-o OUTPUT_FILE] INPUT_FILE
	${prog} -h

ARGUMENTS
	INPUT_FILE           Markdown file to convert

OPTIONS
	-h                   This friendly help message
	-o OUTPUT_FILE    Path to output file
	                  Default: ./[current file name].[expected extention]
	-t OUTPUT_TYPE    Type of file to output: html, pdf, word
	                  Default: pdf

EXAMPLES
    # Generate pdf as ./foo.pdf
    ./${prog} foo.md

	# Generate word file as ~/Documents/foo.docx
	./${prog} -t word -o ~/Document/foo.docx foo.md
EOM
}

# default values
OUTPUT_TYPE=pdf
OUTPUT_FILE=""

# make sure we have pandoc
if ! command -v pandoc >/dev/null 2>&1; then
	echo "${prog}: Missing pandoc, please install" >&2
	exit $ENOENT
fi

# process options
while getopts ho:t: OPT; do
	case "$OPT" in
		h)
			usage
			exit 0
			;;
		o)
			OUTPUT_FILE="$OPTARG"
			;;
		t)
			OUTPUT_TYPE="$OPTARG"
			;;
		*)
			echo "${prog}: Invalid option $OPT" >&2
			usage
			exit $EINVAL
			;;
	esac
done

shift $(( OPTIND - 1 ))

# figure out extension, bail if something not supported
case "$OUTPUT_TYPE" in
	html)
		EXTENSION=".html"
		;;
	pdf)
		EXTENSION=".pdf"
		;;
	word)
		EXTENSION=".docx"
		;;
	*)
		echo "${prog}: Invalid output type $OUTPUT_TYPE" >&2
		exit $EINVAL
		;;
esac

# get out input file
INPUT_FILE="$1"

# determine output file name if not specified
if [ -z "$OUTPUT_FILE" ]; then
	OUTPUT_FILE="${INPUT_FILE%%.*}${EXTENSION}"
fi

# make sure we have pdflatex to pdf
if [ "$OUTPUT_TYPE" = "pdf" ]; then
	if ! command -v pdflatex >/dev/null 2>&1; then
		echo "${prog}: missing \`pdflatex' command needed for pandoc to pdf" \
			>/dev/null 2>&1
		exit $ENOENT
	fi
fi

echo pandoc -o "$OUTPUT_FILE" "$INPUT_FILE"
exec pandoc -o "$OUTPUT_FILE" "$INPUT_FILE"
