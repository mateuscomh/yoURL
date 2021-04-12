#!/usr/bin/env sh

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh
# DATA CRIAÇÃO      : 30/03/2021
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.4
# LICENÇA           : GPL3
# PEQUENA-DESCRIÇÃO : Encurtador de URL e envio de arquivos para 0x0.st.
#
# CHANGELOG : 
#           30/03/2021 - Adicionado cabeçalho e refinado detalhes de formatação
#
#------------------------------------------------------------------------------|


#--------------------------------- VARIÁVEIS ---------------------------------->
fecha="\033[m"
verde="\033[32;1m"
vermelho="\033[31;1m"
branco="\033[37;1m"
#------------------------------- FIM-VARIÁVEIS --------------------------------<


case "$1" in
  -h | --help | '' ) echo "Encurtador de links e  envio de arquivos e imagens para 0x0.st"
  echo $branco "Utilizar postweb.sh + path imagem/arquivo ou endereço" $fecha
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
