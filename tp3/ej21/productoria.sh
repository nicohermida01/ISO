#!/bin/bash

num=(10 3 5 7 9 3 5 4)

productoria() {
  prod=1

  for elem in ${num[@]}; do
    prod=$(( prod * elem ))
  done
}

productoria