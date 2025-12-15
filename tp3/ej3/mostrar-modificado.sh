#!/bin/bash

echo "Menu de opciones:"
echo "1) Mostrar fecha y hora actual"
echo "2) Mostrar nombre de usuario"
echo "3) Mostrar directorio actual"
echo "4) Mostrar directorio personal"
echo "5) Mostrar contenido de un directorio"
echo "6) Mostrar el espacio libre en disco"
echo "7) Salir"

read -p "Seleccione una opción (1-7): " opcion

case $opcion in
    1)
        echo "Fecha y hora actual: "
        date
        ;;
    2)
        echo "Su usuario es: $(whoami)"
        ;;
    3)
        echo "Su directorio actual es: $(pwd)"
        ;;
    4)
        echo "Su directorio personal es: $HOME"
        ;;
    5)
        read -p "Introduzca la ruta del directorio: " dir
        echo "Contenido del directorio $dir:"
        ls "$dir"
        ;;
    6)
        echo "Espacio libre en disco:"
        df -h
        ;;
    7)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opción no válida."
        ;;
esac