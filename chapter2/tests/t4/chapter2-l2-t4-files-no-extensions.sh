#!/bin/bash

#checking for the number of passed arguments
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

#search folder contents, output content without extension
find "$1" -type f | while read file; do
  echo "${file/.*/ }"
done

