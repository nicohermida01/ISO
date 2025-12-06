#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Error: Uso del script $0 <extension>"
  echo "Ejemplo: $0 pdf"
  exit 1
fi

extension=$1
archivo="reporte.txt"

# Creamos el archivo si no existe, si existe lo vaciamos.
> "$archivo"

echo "Usuario Cantidad_de_archivos .${extension}" > "$archivo"

for usuario in /home/*; do
  nombre_usuario=$(basename "$usuario")
  cantidad=$(find "$usuario" -type f -name "*.$extension" -print 2>/dev/null | wc -l)
  echo "$nombre_usuario $cantidad" >> "$archivo"
done

echo "Reporte generado correctamente en $archivo"