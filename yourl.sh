#!/usr/bin/env bash

#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  30/03/2023 GPL3
#  URL shortner and upload files from bash to 0x0.st.
#  Deps: qrencode/zbar, curl, xclip, pbcopy (MacOS)
#----------------------------------------------------|

version='2.3.3'

logo="
██╗   ██╗ ██████╗ ██╗   ██╗██████╗ ██╗     
╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗██║     
 ╚████╔╝ ██║   ██║██║   ██║██████╔╝██║     
  ╚██╔╝  ██║   ██║██║   ██║██╔══██╗██║     
   ██║   ╚██████╔╝╚██████╔╝██║  ██║███████╗
   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝ 
"

usage="yourl.sh - URL shortner and upload files from bash to 0x0.st
  Usage:
    To short links:
        yourl.sh 'URL' URL shortner by http://tinyurl.com
    To sent files:
        yourl.sh 'FILE' File sent to https://0x0.st 

Options:

    -h|--help      Shows help and exit.
    -v|--version   Show running version and exit.
"

case "$1" in
'' | -h | --help)
	echo "$logo $usage"
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
else
	# If $1 is a url
	read -r <<<"$(curl -s http://tinyurl.com/api-create.php?url="$1")"
fi

# Validate read input and exit if error
[[ -z "$REPLY" || "$REPLY" = 'Error' ]] && \
  echo "error: $1 is a invalid argment (not a file neither a URL)" >&2 && \
  exit 1

# Print url shorted on bash
echo "$logo URL created:"
command -v qrencode &>/dev/null && qrencode -m 2 -t ANSIUTF8 "$REPLY"
echo "$REPLY"

# Send a shorted url to clippboard GNU-Linux/MacOS
case $(command -v xclip &>/dev/null && echo "xclip" || echo "pbcopy") in
  xclip) 
    if grep -iq Microsoft /proc/version; then
      printf "%s" "$REPLY" | clip.exe 
    elif command -v xclip > /dev/null; then
      echo -n "$REPLY" | xclip -sel copy
    fi 
    ;;
  pbcopy) echo -n "$REPLY" | pbcopy 2>/dev/null ;;
esac
