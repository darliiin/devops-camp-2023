#!/bin/bash

# Script get a folder as an argument and return a list of unique extensions of all files (including in the nested directories)

# check for the number of passed arguments
if [[ $# -ne 1 ]]; then
    echo "You must specify one folder"
    exit 1
fi

var=$1

touch unique_ext;
echo>unique_ext

# search folder contents, output content without extension
find "$var" -type f | while read file; do
    # check files that contain only one dot in the name
    if [[ $(echo "$file" | grep -o "\." | wc -l) -eq 1  ]]; then
        if [[ ! "${file}" == *"/."* ]]; then
          echo "${file/*./}" >> unique_ext
        fi

    # check files that contain more than one dot in the name
    elif
      [[ $(echo "$file" | grep -o "\." | wc -l) > 1 ]]; then

        # extract filename from file
        file_name="${file##*/}"

        # if the number of dots in the file name is not equal to one, or is equal to one, but the file is not hidden
        if [[ ($(echo "$file_name" | grep -o "\." | wc -l) -ne 1) || ($(echo "$file_name" | grep -o "\." | wc -l) -eq 1 &&  ! "${file_name}" == *"/."*) ]]; then
          echo "${file_name#*.}" >> unique_ext
        fi
    fi
done

sort unique_ext | uniq
