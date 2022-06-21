#!/usr/bin/env sh

#---------------------------------------------------------------------|
#  Matheus Martins 3mhenrique@gmail.com
#  https://github.com/mateuscomh
#  30/03/2021 v1.5  GPL3
#  Encurtador de URL tinyurl e envio de arquivos para 0x0.st.
#  Depends: curl, notify-send, xclip
#---------------------------------------------------------------------|

case "$1" in
  -h | --help | '' ) echo "Encurtador de links e envio de arquivos e imagens para 0x0.st"
    echo "Utilizar postweb.sh + path imagem/arquivo ou endereço" 
  exit 0 ;;
  -v | --version) echo "Versao 1.5"
  exit 0 ;;
  *) 
    if [ ! -f "$1" ] ; then
      TEXT=$(curl -s http://tinyurl.com/api-create.php?url="$1")
      if [ $? -eq "0" ] ; then
        echo "$TEXT"
        notify-send -h int:value:40 "Link encurtado com sucesso"; xmessage -title "Send" -buttons "Close" -nearmouse "$TEXT"
        return 0
      else
        exit 1
      fi
   fi ;;
esac
TEXT=$(curl -sF "file"=@"$1" https://0x0.st | sed -e "s/<.*//")
echo "$TEXT"
notify-send -h int:value:40 "Upload realizado com sucesso"; xmessage -title "Send" -buttons "Close" -nearmouse "$TEXT"
exit 0
