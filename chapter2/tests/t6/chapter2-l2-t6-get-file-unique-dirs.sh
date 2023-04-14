#!/bin/bash

# Checking the number of arguments passed
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

folder=$1

# return a list of unique directories of all files
for file in $(find $folder -type f); do
  echo "${file%/*}"
done | sort -u
