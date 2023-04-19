#!/bin/bash

# Script get a folder as an argument and return all files (including in the nested directories) but without the extension

# checking for the number of passed arguments
if [[ $# -ne 1 ]]; then
  echo "You must specify one folder"
  exit 1
fi

# search folder contents, output content without extension
find "$1" -type f | while read -r file; do

  # check files that contain only one dot in the name
  if [[ $(echo "$file" | grep -o "\." | wc -l) -eq 1 ]]; then

    # if the file is hidden, then display the file name
    if [[ "${file}" == *"/."* ]]; then
      echo "${file}"
    else
      echo "${file%.*}"
    fi

  # check files that contain zero dots in the name
  elif
    [[ $(echo "$file" | grep -o "\." | wc -l) -eq 0 ]]; then
      echo "$file"

  # check files that contain more than one dot in the name
  elif
    [[ $(echo "$file" | grep -o "\." | wc -l) > 1 ]]; then
      file_path=$(dirname "$file")
      file_name="${file##*/}"

      # remove the extension if the file name: contains more than 1 dot
      # OR the file is not hidden and has the extension
      if [[ ($(echo "$file_name" | grep -o "\." | wc -l) -ne 1) || \
            ($(echo "$file_name" | grep -o "\." | wc -l) -eq 1) && ! ("${file_name:0:1}" == ".") ]]; then
        echo "${file_path}/${file_name%%.*}"

      # output the file name unchanged if the file does not contain dots
      # OR it is a hidden file
      elif [[ ($(echo "$file_name" | grep -o "\." | wc -l) -eq 0) || \
              ($(echo "$file_name" | grep -o "\." | wc -l) -eq 1) && ("${file_name:0:1}" == ".") ]]; then
        echo "${file_path}/${file_name}"
      fi
  fi

done
