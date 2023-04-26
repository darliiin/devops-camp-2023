#!/bin/bash

# Script get a folder as an argument and return a list of unique extensions of all files (including in the nested directories)

# check for the number of passed arguments
if [[ $# -ne 1 ]]; then
    echo "You must specify one folder"
    exit 1
fi

folder=$1

# search folder contents, output content without extension
find "$folder" -type f | while read  file; do

  # check files that contain only one dot in the name
  if [[ $(echo "$file" | grep -o "\." | wc -l) -eq 1  ]]; then
    if [[ ! "${file}" == *"/."* ]]; then
      echo "${file/*./}"
    fi

  # check files that contain more than one dot in the name
  elif [[ $(echo "$file" | grep -o "\." | wc -l) -gt 1 ]]; then

    # extract filename from file
    file_name="${file##*/}"

    # skip files without extension and hidden files without extension
    if [[ ($(echo "$file_name" | grep -o "\." | wc -l) -eq 0) || \
          ($(echo "$file_name" | grep -o "\." | wc -l) -eq 1 &&  "${file_name:0:1}" == ".") ]]; then
      continue

    # write the extension to the file if the number of points is not equal to 1 or equal to one
    # but the file is not hidden
    elif [[ ($(echo "$file_name" | grep -o "\." | wc -l) -eq 1 &&  ! "${file_name:0:1}" == ".") ||
            ($(echo "$file_name" | grep -o "\." | wc -l) -ne 1) ]]; then
      echo "${file_name#*.}"
    fi
  fi

done | sort -u
