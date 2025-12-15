#!/bin/bash

ls | tr 'A-Za-z' 'a-zA-Z' | tr -d 'aA'

