#!/bin/bash

if [ $# -ne 2 ]; then
  # Si no se pasaron exactamente dos parametros
  echo "Error. Uso del script: $0 numero1 numero2"
  exit 1
fi

num1=$1
num2=$2

suma=$(($num1 + $num2))
multi=$(($num1 * $num2))
resta=$(($num1 - $num2))

if [ $num1 -gt $num2 ]; then
  mayor=$num1
elif [ $num2 -gt $num1 ]; then
  mayor=$num2
else
  mayor="Los numeros son iguales"
fi

echo "La suma de los numeros es: $suma"
echo "La multiplicacion de los numeros es: $multi"
echo "La resta de los numeros es: $resta"
echo "El numero mayor es: $mayor"
