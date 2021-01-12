#!/usr/bin/env sh

case "$1" in
  -h | --help ) echo "Programa para encurtar links e realizar envio de arquivos e imagens para 0x0.st em shell"
  echo "postweb.sh + caminho imagem/arquivo ou endereço"
  echo "Autor: pekman/Mateuscomh - Djangoo"
  exit 0
  ;;

  -v | --version) echo "Versao 1.4"
  exit 0
  ;;

  *)
    if [ ! -f "$1" ] ; then
      TEXT=$(curl -sF"shorten=$1" https://0x0.st)
      echo "$TEXT"
      notify-send -h int:value:40 "Link encurtado com sucesso"; xmessage -title "Send" -buttons "Close" -nearmouse "$TEXT"
      exit 0
   fi
      ;;
esac

TEXT=$(curl -sF "file"=@"$1" https://0x0.st | sed -e "s/<.*//")
echo "$TEXT"
notify-send -h int:value:40 "Upload realizado com sucesso"; xmessage -title "Send" -buttons "Close" -nearmouse "$TEXT"

exit 0
