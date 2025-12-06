#!/bin/bash

echo "Menu de opciones: "
echo "1. Listar"
echo "2. DondeEstoy"
echo "3. QuienEsta"
read -p "Ingrese una de las opciones (1, 2 o 3)" opcion

case $opcion in
  1) 
    echo "Contenido del directorio actual: "
    ls
    ;;
  2) 
    echo "Ruta del directorio actual: "
    pwd
    ;;
  3) 
    echo "Usuarios conectados al sistema:"
    who
    ;;
  *)
    echo "Opcion invalida"
    exit 1
    ;;
esac

exit 0