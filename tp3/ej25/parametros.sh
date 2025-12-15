#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Error: uso del script: $0 dir1 [dir2 ... dirN]"
  exit 1
fi

inexistentes=0

for (( i=1; i<=$#; i+=2 )); do
  parametro=${!i}
  
  if [ -e "$parametro" ]; then
    if [ -f "$parametro" ]; then
      echo "$parametro es un archivo."
    elif [ -d "$parametro" ]; then
      echo "$parametro es un directorio."
    fi
  else
    echo "$parametro no existe."
    inexistentes=$((inexistentes + 1))
  fi
done

echo "Cantidad de archivos o directorios inexistentes: $inexistentes"