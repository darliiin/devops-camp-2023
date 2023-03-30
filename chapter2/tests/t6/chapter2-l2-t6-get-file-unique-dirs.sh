#!/bin/bash
#Checking the number of arguments passed
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi
#return a list of unique directories of all files
for file in $(find $1 -type f); do
  if [[ ! "${arr[@]}" =~ $file ]]; then
    arr+=$file
    echo $file
  fi
done






