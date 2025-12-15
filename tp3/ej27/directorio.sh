#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Error: no se pasaron parametros"
  echo "Uso del script: $0 <directorio>"
  exit 1
fi

dir=$1
archivos_rw=0

if [ -d $dir ]; then
  for archivo in "$dir"/*; do
    if [ -f $archivo ]; then
      if [[ -r $archivo && -w $archivo ]]; then
        echo $archivo
        archivos_rw=$(( archivos_rw + 1 ))
      else
        echo "El archivo $archivo no tiene permisos de lectura y escritura"
      fi
    else
      echo "El archivo $archivo no es un archivo regular"
    fi
  done
else
  echo "El directorio no existe o el path no corresponde a un directorio"
  exit 4
fi

echo "Cantidad de archivos con permisos de lectura y escritura: $archivos_rw"