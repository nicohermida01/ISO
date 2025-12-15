#!/bin/bash

mensaje="Error: Uso del script: $0 numero1 operador numero2"

if [ $# -ne 3 ]; then
  echo $mensaje
  exit 1
fi

num1=$1
operador=$2
num2=$3

case $operador in
  +)
    resultado=$((num1 + num2))
    ;;
  -)
    resultado=$((num1 - num2))
    ;;
  \*)
    resultado=$((num1 * num2))
    ;;
  /)
    if [ $num2 -eq 0 ]; then
      echo "Error: división por cero"
      exit 1
    fi
    resultado=$((num1 / num2))
    ;;
  *)
    echo "Error: Operador invalido. Operadores validos: +, -, *, /"
    echo $mensaje
    exit 1
    ;;
esac

echo "Resultado: $resultado"
exit 0