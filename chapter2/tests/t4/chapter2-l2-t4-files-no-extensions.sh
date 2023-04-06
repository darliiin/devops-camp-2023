#!/bin/bash

# checking for the number of passed arguments
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

# search folder contents, output content without extension
find "$1" -depth -type f | while read file; do
  if [[ $(echo "$file" | grep -o "\." | wc -l) -eq 1 && "${file##*/}" == .* ]]; then
    echo "$file"
  else
    echo "${file%.*}"
  fi

done
