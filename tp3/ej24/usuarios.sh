#!/bin/bash

grupo="users"
usuarios=($(getent group $grupo | awk -F: '{print $4}' | tr ',' ' '))


if [ $# -eq 0 ]; then
  echo "Error: uso del script: $0 [-b n | -l | -i]"
  exit 1
fi

opcion=$1

case $opcion in
  -b)
    if [ $# -ne 2 ]; then
      echo "Error: uso del script: $0 [-b n | -l | -i]"
      exit 1
    fi
    pos=$2

    if [ ${#usuarios[@]} -ge $(( pos + 1 )) ]; then
      echo "Usuario: ${usuarios[pos]}"
    else
      echo "Error: Posicion invalida."
      exit 1
    fi
    ;;  
  -l)
    echo "Cantidad de usuarios: ${#usuarios[@]}"
    ;;
  -i)
    for user in ${usuarios[@]}; do
      echo $user
    done 
    ;;
  *)
    echo "Error: Opcion invalida"
    exit 1
esac

exit 0