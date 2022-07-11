#!/bin/bash

prog=${0##*/}


usage() {
	cat <<EOM
${prog} USAGE

	${prog} [-o OUTFILE] [-d DOMAIN_PATTERN] OLD_PATTERN NEW_PASSWORD INFILE
	${prog} -h

${prog} replaces passwords in the Firefox password manager export csv file with
a new one

ARGUMENTS

	INFILE 			input logins.csv formatted file
	OLD_PATTERN 	regex to look against
	NEW_PASSWORD 	new password string

OPTIONS

	-d DOMAIN_PATTERN 	Limit replacements to a regex against the domain
	-h					This handy help message
	-o OUFTILE			Specify the output file.  Otherwise it will write to
	                    ./logins.new.csv
EOM
}

DOMAIN_PATTERN=".*"
OUTFILE="./logins.new.csv"
while getopts d:ho: OPT; do
	case "$OPT" in
		d)
			DOMAIN_PATTERN="$OPTARG"
			;;
		h)
			usage
			exit 0
			;;
		o)
			OUTFILE="$OPTARG"
			;;
		*)
			echo "Invalid argument: ${OPT}"
			exit 22
			;;

	esac
done

shift $((OPTIND - 1))

if [ -z "$1" ]; then
	echo "Missing required argument: OLD_PATTERN"
	usage
	exit 22
fi
OLD_PATTERN="$1"
shift

if [ -z "$1" ]; then
	echo "Missing required argument: NEW_PASSWORD"
	usage
	exit 22
fi
NEW_PASSWORD="$1"
shift

if [ -z "$1" ]; then
	echo "Missing required argument: INFILE"
	usage
	exit 22
fi
INFILE="$1"

TFILE=$(mktemp ".$prog.XXXXXX")
trap 'rm -f $TFILE' EXIT

cat > "$TFILE" <<EOF
BEGIN {
	FS=","
	OFS=","
}
{
	matched=0
}
\$3 ~ /${OLD_PATTERN}/ && (\$1 ~ /${DOMAIN_PATTERN}/ || \$5 ~ /${DOMAIN_PATTERN}/) {
	matched=1
	print \$1,\$2,"${NEW_PASSWORD}",\$4,\$5,\$6,\$7,\$8,\$9
}
matched == 0 { print \$0 }
EOF

awk -f "$TFILE" "$INFILE" > "$OUTFILE"
