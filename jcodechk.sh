#!/usr/bin/env bash
#
# jcodechk.sh - check {JSON-9999} codes generated by a tool
#
# Copyright (c) 2022 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)


# setup
#
export USAGE="usage: $0 [-h] [-v level] [-D dbg_level] [-s] jchktool file.json

    -h			print help and exit 2
    -v level		set verbosity level for this script: (def level: 0)
    -D dbg_level	set verbosity level to pass to jchktool (def: level: 0)
    -s			strict mode: be more strict on what is allowed (def: not strict)

    jchktool		path to a JSON check tool such as ./jinfochk or ./jauthchk
    file.json		a JSON filename to check

    NOTE: There must also exist file.json.code containing expected {JSON-9999} codes.

exit codes:
    0 - all is well
    1 - {JSON-9999} codes generated by jchktool on file.json
        did not match the {JSON-9999} codes found in file.json.code
    2 - no readable file.json file was found
    3 - no readable file.json.code file was found
    4 - no jchktool was found or is not executable
    5 - usage message printed due to -h
    6 - command line error
    >= 7 - internal error"
export EXIT_CODE=0
export JSON_TREE="./test_JSON"
export LOGFILE="./json_test.log"
export STRICT=""

# parse args
#
export V_FLAG="0"
export DBG_LEVEL="0"
while getopts :hv:D:s flag; do
    case "$flag" in
    h) echo "$USAGE" 1>&2
       exit 5
       ;;
    v) V_FLAG="$OPTARG";
       ;;
    D) DBG_LEVEL="$OPTARG";
       ;;
    s) STRICT="-s"
       ;;
    \?) echo "$0: ERROR: invalid option: -$OPTARG" 1>&2
       exit 6
       ;;
    :) echo "$0: ERROR: option -$OPTARG requires an argument" 1>&2
       exit 6
       ;;
   *)
       ;;
    esac
done

# check args
#
shift $(( OPTIND - 1 ));
if [[ $# -ne 2 ]]; then
    echo "$0: ERROR: expected 2 arguments, found $#" 1>&2
    exit 6
fi
JCHKTOOL="$1"
FILE_JSON="$2"
export JCHKTOOL FILE_JSON

# firewall
#
if [[ ! -e $JCHKTOOL ]]; then
    echo "$0: ERROR: jchktool does not exist: $JCHKTOOL" 1>&2
    exit 4
fi
if [[ ! -f $JCHKTOOL ]]; then
    echo "$0: ERROR: jchktool is not a regular file: $JCHKTOOL" 1>&2
    exit 4
fi
if [[ ! -x $JCHKTOOL ]]; then
    echo "$0: ERROR: jchktool is not executable: $JCHKTOOL" 1>&2
    exit 4
fi
if [[ ! -e $FILE_JSON ]]; then
    echo "$0: ERROR: file.json does not exist: $FILE_JSON" 1>&2
    exit 2
fi
if [[ ! -f $FILE_JSON ]]; then
    echo "$0: ERROR: file.json is not a regular file: $FILE_JSON" 1>&2
    exit 2
fi
if [[ ! -r $FILE_JSON ]]; then
    echo "$0: ERROR: file.json is not a readable file: $FILE_JSON" 1>&2
    exit 2
fi
export CODE_JSON="$FILE_JSON.code"
if [[ ! -e $CODE_JSON ]]; then
    echo "$0: ERROR: file.json.code does not exist: $CODE_JSON" 1>&2
    exit 3
fi
if [[ ! -f $CODE_JSON ]]; then
    echo "$0: ERROR: file.json.code is not a regular file: $CODE_JSON" 1>&2
    exit 3
fi
if [[ ! -r $CODE_JSON ]]; then
    echo "$0: ERROR: file.json.code is not a readable file: $CODE_JSON" 1>&2
    exit 3
fi
export TMPFILE="/var/tmp/jcodechk.$$"
if [[ -e $TMPFILE ]]; then
    echo "$0: ERROR: TMPFILE file exists: $TMPFILE" 1>&2
    exit 7
fi
touch "$TMPFILE"
status="$?"
if [[ $status -ne 0 || ! -e $TMPFILE ]]; then
    echo "$0: ERROR: cannot create file: $TMPFILE" 1>&2
    exit 7
fi
trap "rm -f \$TMPFILE; exit" 0 1 2 3 15
if [[ ! -f $TMPFILE ]]; then
    echo "$0: ERROR: TMPFILE is not a regular file: $TMPFILE" 1>&2
    exit 7
fi
if [[ ! -w $TMPFILE ]]; then
    echo "$0: ERROR: TMPFILE is not a writable file: $TMPFILE" 1>&2
    exit 7
fi
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: jchktool: $JCHKTOOL" 1>&2
    echo "$0: debug[5]: file.json: $FILE_JSON" 1>&2
    echo "$0: debug[5]: file.json.code $CODE_JSON" 1>&2
    echo "$0: debug[5]: TMPFILE: $TMPFILE" 1>&2
fi

# collect the expected JSON codes
#
CODE_EXPECTED=$(sed -n -E 's/.*{(JSON-[0-9]{4})}.*/\1/gp' "$CODE_JSON" | sort -u)
export CODE_EXPECTED
if [[ $V_FLAG -ge 7 ]]; then
    echo "$0: debug[7]: codes expected: $CODE_EXPECTED" 1>&2
fi
if [[ $V_FLAG -ge 1 && -z $CODE_EXPECTED ]]; then
    echo "$0: debug[1]: no codes found in: $CODE_JSON" 1>&2
fi

# run the jchktool and capture the output
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: about to execute: $JCHKTOOL -v $DBG_LEVEL $STRICT -- $FILE_JSON > $TMPFILE 2>&1" 1>&2
fi
"$JCHKTOOL" -v "$DBG_LEVEL" "$STRICT" -- "$FILE_JSON" > "$TMPFILE" 2>&1
status="$?"
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: jchktool exit code: $status" 1>&2
fi
if [[ $status -eq 127 ]]; then
    echo "$0: ERROR: failed to run jchktool: $JCHKTOOL" 1>&2
    exit 7
fi

# collect the codes generated by jchktool
#
CODE_FOUND=$(sed -n -E 's/.*{(JSON-[0-9]{4})}.*/\1/gp' "$TMPFILE" | sort -u)
export CODE_FOUND
if [[ $V_FLAG -ge 7 ]]; then
    echo "$0: debug[7]: codes generated: $CODE_FOUND" 1>&2
fi
if [[ $V_FLAG -ge 1 && -z $CODE_FOUND ]]; then
    echo "$0: debug[1]: no codes generated by: $JCHKTOOL -v $DBG_LEVEL $FILE_JSON"
fi

# determine if the codes expected match the codes found
#
if [[ $CODE_FOUND != "$CODE_EXPECTED" ]]; then
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: codes generated do not match codes expected" 1>&2
    fi
    if [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: difference between codes expected and codes generated follows:" 1>&2
	diff -y <( echo "$CODE_EXPECTED" ) <( echo "$CODE_FOUND" ) 1>&2
    fi
    rm -f "$TMPFILE"
    exit 1
fi
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: all codes generated are expected" 1>&2
fi
rm -f "$TMPFILE"
exit 0
