#!/bin/bash 

array=()

inicializar() {
  array=()
}

agregar_elem() {
  if [ $# -eq 0 ]; then
    echo "Error: no se ha pasado el elemento a agregar."
  else
    array+=($1)
  fi
}

eliminar_elem() {
  if [ $# -eq 0 ]; then
    echo "Error: no se ha pasado el indice del elemento a eliminar."
  else
    pos=$1

    if [ $pos -ge 0 ] && [ $pos -lt ${#array[@]} ]; then
      unset array_vacio[$pos]
      array=(${array[@]}) # Tenemos que reindexar el arreglo
    else
      echo "Error: posicion invalida."
    fi
  fi
}

longitud() {
  echo "Longitud del arreglo: ${#array[@]}"
}

imprimir() {
  for elem in ${array[@]}; do
    echo $elem
  done
}

inicializar_con_valores() {
  inicializar
  for (( i=0; i<$1; i++ )); do
    array+=($2)
  done
}   