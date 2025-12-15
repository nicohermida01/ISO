#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Error"
fi

for parametro in $@; do
  echo $parametro
done