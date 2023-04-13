#!/bin/bash

# getting a list of all unique files with extensions but no absolute path

# сhecking the number of arguments passed
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

var=$1

# create an array
file_name=()

# return a list of all unique files with extensions without the absolute path
find "$var" -type f | while read -r file; do
  if [[ ! "${file_name[@]}" =~ "${file##*/}" ]]; then
    file_name+="${file##*/}"
    echo "${file##*/}"
  fi
done
