#!/bin/bash

pila=()

push() {
  # Agrega un elemento en el tope de la pila (final del array)
  # Podriamos verificar que se este enviando el parametro con if pero como no se invoca desde fuera del script no es necesario.
  pila+=("$1")
}

pop() {
  # Elimina el elemento en el tope de la pila (ultimo elemento del array)
  if [ ${#pila[@]} -eq 0 ]; then
    echo "La pila no tiene elementos para eliminar"
  else
    unset pila[-1] 
  fi
}

length() {
  # Imprime la longitud de la pila (longitud del array)
  echo "${#pila[@]}" 
}

print() {
  # Imprime todos los elementos de la pila.
  for elemento in "${pila[@]}"; do
    echo $elemento
  done
}

while true; do
  echo "Seleccione una de las opciones del menu:"
  echo "1) Agregar 10 elementos a la pila"
  echo "2) Eliminar 3 elementos de la pila"
  echo "3) Imprimir la cantidad de elementos de la pila"
  echo "4) Imprimir los elementos de la pila"
  echo "5) Salir."
  read -p "Ingrese una de las opciones" opcion

  case $opcion in
    1)
      # Agregar 10 elementos a la pila
      for i in {1..10}; do
        push "Elemento_$i"
      done 
      ;;
    2)
      # Eliminar 3 elementos de la pila
      for i in {1..3}; do
        pop
      done
      ;;
    3)
      # Imprimir length
      echo "La pila tiene $(length) elementos"
      ;;
    4)
      # Imprimir los elementos de la pila
      echo "Elementos de la pila: "
      print
      ;;
    5)
      echo "Saliendo..."
      exit 0
      ;;
    *)
      echo "Opcion invalida. Ingresar una de las opciones mostradas (1..5)"
      ;;
  esac
done