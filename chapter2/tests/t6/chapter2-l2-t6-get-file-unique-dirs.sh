#!/bin/bash

# Checking the number of arguments passed
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

folder=$1

# return a list of unique directories of all files
find "$folder" -type f | while read -r file; do
  echo "${file%/*}"
done | sort -u
