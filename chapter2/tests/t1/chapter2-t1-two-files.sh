#!/bin/bash

# check for a valid number of arguments
if [[ "$#" != 2 ]]; then
  echo "Enter two arguments"
  exit 1
fi

# check if file exists
for file in "$@"; do

  if [[ "$file" == */* ]]; then

    # extract directory path
    dir="${file%/*}"

    # create directory if it does not exist
    if [[ ! -d "$dir" ]]; then
      mkdir -p "$dir"
    fi
  fi

  # if the file does not exist
  if [[ ! -f "$file" ]]; then
    rstring=$(openssl rand -base64 8)
    echo "$rstring" | base64 > "$file"
    chmod 700 "$file"
    echo "new file: $file"

  # if the file exists
  else
    echo "$file:"
    cat "$file" 2>/dev/null
    echo ""
  fi
done
