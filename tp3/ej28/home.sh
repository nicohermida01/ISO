#!/bin/bash

archivos_doc=()

for archivo in /home/*.doc; do
  if [ -f $archivo ]; then
    archivos_doc+=($archivo)
  fi
done

verArchivo() {
  if [ $# -lt 1 ]; then
    echo "Error: no se paso el nombre del archivo"
    exit 1
  else
    flag=0
    for archivo in ${archivos_doc[@]}; do
      nombre_archivo=${basename $archivo}
      if [ $nombre_archivo -eq $archivo ]; then
        flag=1
      fi
    done

    if [ $flag -eq 1 ]; then
      cat $archivo
    else
      echo "Error: Archivo no encontrado"
      exit 5
    fi
  fi
}

cantidadArchivo() {
  echo "Cantidad de arcivos .doc en /home: ${#archivos_doc[@]}"
}

borrarArchivo() {
  if [ $# -lt 1 ]; then
    echo "Error: no se paso el nombre del archivo"
    exit 1
  else
    flag=0
    for i in ${!archivos_doc[@]}; do
      nombre_archivo=${basename ${archivos_doc[i]}}
      if [ $nombre_archivo -eq $1 ]; then
        flag=1
        indice=$i
      fi
    done

    if [ $flag -eq 1 ]; then
      read -p "¿Desea eliminar el archivo lógicamente? (Si/No): " respuesta
      if [ "$respuesta" == "Si" ]; then
        unset archivos_doc[$indice]
        archivos_doc=("${archivos_doc[@]}") # Reindexar el arreglo
      elif [ "$respuesta" == "No" ]; then
        rm "${archivos_doc[$indice]}"
        unset archivos_doc[$indice]
        archivos_doc=("${archivos_doc[@]}") # Reindexar el arreglo
      else
        echo "Respuesta inválida. Use 'Si' o 'No'."
      fi
    else
      echo "Error: Archivo no encontrado"
      exit 10
    fi
  fi
}