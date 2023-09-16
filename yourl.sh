#!/usr/bin/env bash

#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2021 GPL3
#  URL shortner and upload files from bash to 0x0.st.
#----------------------------------------------------|

version='2.1.0'

usage="yourl.sh - URL shortner and upload files from bash to 0x0.st

██╗   ██╗ ██████╗ ██╗   ██╗██████╗ ██╗     
╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗██║     
 ╚████╔╝ ██║   ██║██║   ██║██████╔╝██║     
  ╚██╔╝  ██║   ██║██║   ██║██╔══██╗██║     
   ██║   ╚██████╔╝╚██████╔╝██║  ██║███████╗
   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝     

  Usage:
    To short links:
        yourl.sh 'URL' URL shortner by http://tinyurl.com
    To sent files:
        yourl.sh 'FILE' File sent to https://0x0.st 

Options:

    -h|--help      Shows help and exit.
    -v|--version   Show running version and exit.
"

op_short='short link '
op_upload='file sent'

case "$1" in
'' | -h | --help)
  echo "$usage"
  exit
  ;;
-v | --version)
  echo "$version"
  exit
  ;;
esac

if [[ -f "$1" ]]; then
  # If $1 is file
  read -r <<<"$(curl -sF "file=@$1" https://0x0.st | sed -e "s/<.*//")"
  op="$op_upload"
else
  # If $1 is a url
  read -r <<<"$(curl -s http://tinyurl.com/api-create.php?url="$1")"
  op="$op_short"
fi

# Validate read input and exit if error
[[ -z "$REPLY" || "$REPLY" = 'Error' ]] && exit 1

# Print url shorted on bash
#echo "$REPLY"
command -v qrencode &>/dev/null && qrencode -m 2 -t ANSIUTF8 "$REPLY"
echo "$REPLY"

# Send a shorted url to clippboard Linux/MacOS
command -v xclip &>/dev/null && echo -n "$REPLY" | xclip -sel copy || echo -n "$REPLY" | pbcopy 2>/dev/null
