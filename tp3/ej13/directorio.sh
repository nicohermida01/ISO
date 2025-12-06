#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Error: Uso del script: $0 archivo"
  exit 1
fi

archivo=$1

if [ -e $archivo ]; then
  echo "El archivo $archivo existe"
  if [ -f $archivo ]; then
    echo "$archivo es un archivo regular"
  elif [ -d $archivo ]; then
    echo "$archivo es un directorio"
  fi
else
  echo "El archivo $archivo no existe"
  mkdir $archivo
  echo "Se creo el directorio $archivo"
fi