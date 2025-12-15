#!/bin/bash

for i in {1..100}; do
  cuadrado=$(($i * $i))
  echo "Numero: $i, Cuadrado: $cuadrado"
done