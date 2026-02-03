#!/usr/bin/env bash
#----------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh/yoURL
#  Modified version with local pastebin support
#  URL shortner and upload files from bash
#----------------------------------------------------|
version='2.6.1'

PASTEBIN_URL="${PASTEBIN_URL:-http://localhost:9998}"
logo="
██╗   ██╗ ██████╗ ██╗   ██╗██████╗ ██╗     
╚██╗ ██╔╝██╔═══██╗██║   ██║██╔══██╗██║     
 ╚████╔╝ ██║   ██║██║   ██║██████╔╝██║     
  ╚██╔╝  ██║   ██║██║   ██║██╔══██╗██║     
   ██║   ╚██████╔╝╚██████╔╝██║  ██║███████╗
   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝ 
"
usage="yourl.sh - URL shortner and upload files from bash
Version: $version
    Usage:
    To short links:
        yourl.sh 'URL' URL shortner by http://tinyurl.com
    To send files:
        yourl.sh 'FILE' File sent to local pastebin server
                        Falls back to termbin.com if local server is unavailable
        
  Environment Variables:
    PASTEBIN_URL   Set your pastebin server URL (default: http://localhost:8000)
                   Example: export PASTEBIN_URL=http://192.168.1.100:8000
                   
  Dependencies:
    - curl (required)
    - nc/netcat (required for termbin.com fallback)
    - xclip or pbcopy (optional, for clipboard)
    - qrencode (optional, for QR codes)
    
Options:
    -h|--help      Shows help and exit.
    -v|--version   Show running version and exit.
"

is_url() {
    local input="$1"
    # Check for http(s):// prefix
    [[ "$input" =~ ^https?:// ]] && return 0
    # Check for www. prefix
    [[ "$input" =~ ^www\. ]] && return 0
    # Check for domain pattern (e.g., google.com, github.com)
    [[ "$input" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)+$ ]] && return 0
    return 1
}

check_pastebin() {
    curl -sf -m 2 "$PASTEBIN_URL" &>/dev/null
}

upload_file() {
    local file="$1" response url use_termbin=false
    
    # Check pastebin availability
    if ! check_pastebin; then
        echo "⚠️  Local pastebin unavailable at $PASTEBIN_URL" >&2
        read -p "Use termbin.com (external)? [Y/n]: " choice
        [[ "$choice" =~ ^[Nn] ]] && { echo "Cancelled." >&2; return 1; }
        use_termbin=true
    fi
    
    # Try local pastebin
    if [[ "$use_termbin" == false ]]; then
        response=$(curl -sS -m 5 -X POST "$PASTEBIN_URL" -F "file=@$file" 2>&1)
        
        if [[ $? -eq 0 && -n "$response" ]]; then
            url=$(echo "$response" | tr -d '\n\r' | xargs)
            
            if [[ "$url" =~ ^https?:// ]]; then
                echo "$url"
                return 0
            elif [[ -n "$url" ]]; then
                echo "$PASTEBIN_URL/${url#/}"
                return 0
            fi
        fi
        
        # Local failed, ask for termbin
        echo "Upload failed." >&2
        read -p "Try termbin.com instead? [Y/n]: " choice
        [[ "$choice" =~ ^[Nn] ]] && { echo "Cancelled." >&2; return 1; }
        use_termbin=true
    fi
    
    # Use termbin
    if [[ "$use_termbin" == true ]]; then
        command -v nc &>/dev/null || { echo "Error: nc required for termbin" >&2; return 1; }
        
        response=$(cat "$file" | nc termbin.com 9999 2>&1)
        url=$(echo "$response" | tr -d '\n\r' | xargs)
        
        [[ "$url" =~ ^https?:// ]] && { echo "$url"; return 0; }
    fi
    
    echo "Error: Upload failed" >&2
    return 1
}

# Parse arguments
case "$1" in
    ''|-h|--help) echo "$logo"; echo "$usage"; exit 0 ;;
    -v|--version) echo "$version"; exit 0 ;;
esac

[[ -z "$1" ]] && { echo "Error: No argument" >&2; exit 1; }

# Process file or URL
if [[ -f "$1" ]]; then
    read -r REPLY < <(upload_file "$1")
elif [[ -e "$1" ]]; then
    echo "Error: Not a regular file" >&2; exit 1
elif is_url "$1"; then
    url="$1"
    # Add http:// if no protocol
    [[ ! "$url" =~ ^https?:// ]] && url="http://$url"
    # URL encode the URL for tinyurl API
    encoded_url=$(printf %s "$url" | jq -sRr @uri 2>/dev/null || python3 -c "import urllib.parse; print(urllib.parse.quote('''$url''', safe=':/'))" 2>/dev/null || echo "$url")
    read -r REPLY < <(curl -sS "http://tinyurl.com/api-create.php?url=$encoded_url")
else
    echo "Error: '$1' is not a file or URL" >&2; exit 1
fi

# Validate result
[[ -z "$REPLY" || "$REPLY" == *"error"* ]] && { echo "Error: Failed to process" >&2; exit 1; }

# Output
echo "$logo"
echo "URL created:"
command -v qrencode &>/dev/null && qrencode -m 2 -t ANSIUTF8 "$REPLY"
echo "$REPLY"

# Clipboard
if command -v xclip &>/dev/null && [ -n "$DISPLAY" ]; then
    echo -n "$REPLY" | xclip -sel copy && echo "(Copied to clipboard)" >&2
elif command -v pbcopy &>/dev/null; then
    echo -n "$REPLY" | pbcopy && echo "(Copied to clipboard)" >&2
elif grep -iq Microsoft /proc/version 2>/dev/null; then
    printf "%s" "$REPLY" | clip.exe
fi
