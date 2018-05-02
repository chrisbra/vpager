#!/bin/sh

# Shell script to be used as pager from inside Vims Terminal
#
# The output will be send to Vim to be opened in a new buffer
#
# Author: Christian Brabandt <cb@256bit.org>
# License: BSD
VERSION=0.1

#set -x

ESC=`printf "\e"`
BELL=`printf "\a"`
PRE=${ESC}']51;["call", "Tapi_Vpager", '
POST=']'${BELL}
SEQ=`date +"%s"`
VIMOPT=""
NEW=""

main(){
  # The interface is something like this:
  # <ESC>]51;["call", "Tapi_Vpager", [args]]
  # with args a list with the following elements:
  # 0] vpager:<unix_timestamp>:
  # 1] vim options
  # 2] output to be copied into a vim buffer, one item per line
  #
  # The Unix timestamp is there to distinguish between each call of vpager,
  # so while `seq 1 10 | vpager ` will only call vpager once, it is not clear
  # from inside vim when a single session stopped, so add a timestamp there
  #
  # vim options: to be set, e.g. filetype
  # only do it, if run inside a Vim terminal, e.g. VIM_SERVERNAME is set
  if [ -z "${VIM_SERVERNAME+x}" ]; then
    # variable unset, not running inside Vim, so simply dump out the input
    echo `cat`
  else
    while read line; do
      echo "$line" | sed -e "s/.*/${PRE} [\"vpager:${SEQ}:${NEW}\", \"${VIMOPT}\", \"\0\"]${POST}\0/"
    done
  fi
}

display_help(){
cat << EOF
NAME

    This script `basename $0` can be used as pager from inside Vims built-in
    terminal. The output will be copied to a new buffer in Vim.

SYNOPSIS
    `basename $0` [-n -C option]
    `basename $0` [-h|-v]

    -v	display version
    -h	display help
    -C	Pass options to Vim. Can be used to e.g. set the filetype for
        correct syntax highlighting.
    -n  Clear the previous buffer in Vim

EXAMPLES
  git diff | vpager -nC 'ft=diff'

  Copies the output of git diff into a buffer inside Vim. Any previous
  output in the buffer will be cleared and the filetype will be set
  to "diff", for proper syntax highlighting.
EOF
}

getVersion(){
cat <<EOF
$(basename "${0}") Version: ${VERSION}
EOF
}

# Process commandline parameters
while getopts "nhvC:" ARGS; do
  case ${ARGS} in
    v) getVersion; exit 0 ;;
    C) VIMOPT=${OPTARG} ;;
    n) NEW="new" ;;
    h) display_help; exit 0 ;;
    ?) display_help; exit 0 ;;
    *) display_help; exit 1 ;;
  esac
done

shift `expr ${OPTIND} - 1`

main
