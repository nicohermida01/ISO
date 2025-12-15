#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Error: Uso del script: $0 directorio opcion(-a / -b) cadena"
  exit 1 
fi

directorio=$1
opcion=$2
cadena=$3

if [ ! -d $directorio ]; then
  echo "Error: $directorio no es un directorio valido."
  exit 1
fi

for archivo in "${directorio}"/*; do
  if [ -f $archivo ]; then
    nombre_archivo=$(basename "$archivo") # Obtengo el nombre indivual del archivo para poder formatearlo despues.
    ruta_archivo=$(dirname "$archivo") # Obtengo la ruta al archivo para poder concatenarlo al nombre final.

    case $opcion in
      -a)
        ## Agregar cadena al final
        nuevo_nombre="${nombre_archivo}${cadena}"
        ;;
      -b)
        ## Agregar cadena al principio
        nuevo_nombre="${cadena}${nombre_archivo}"
        ;;
      *)
        echo "Opcion invalida. Usar -a o -b."
        exit 1
        ;;
    esac

    mv "$archivo" "$ruta_archivo/$nuevo_nombre"
    echo "Renombrado: $archivo -> $ruta_archivo/$nuevo_nombre"
  fi
done