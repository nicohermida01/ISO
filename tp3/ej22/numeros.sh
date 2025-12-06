#!/bin/bash

numeros=(0 1 2 3 4 5 6 7 8 9)
impares=()

echo "Pares: "
for num in ${numeros[@]}; do
  if [ $(( num % 2 )) = 0 ]; then
    echo $num
  else
    impares+=($num)
  fi
done

echo "Impares: "
for impar in ${impares[@]}; do
  echo $impar
done

