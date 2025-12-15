#!/bin/bash
vector1=(1 80 65 35 2)
vector2=(5 98 3 41 8)

length=${#vector1[@]}


for (( i=0; i<length; i++ )); do
  suma=$(( vector1[i] + vector2[i] ))
  echo "La suma de los elementos de la posición $i de los vectores es $suma"
done