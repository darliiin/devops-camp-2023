#!/bin/bash

# getting a list of all unique files with extensions but no absolute path

# сhecking the number of arguments passed
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

folder=$1

# all unique files with extensions without the absolute path
find "$folder" -type f | while read -r file; do
  file_name="${file##*/}"
  echo "${file_name}"
done | sort -u
