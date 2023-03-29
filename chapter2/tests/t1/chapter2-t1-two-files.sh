#!/bin/bash

if [[ "$#" = 2 ]]; then
    file1="$1"
    file2="$2"
    if [[ -f "$file1" ]] && [[ -f "$file2" ]]; then
        echo "$file1:"
        cat "$file1"
        echo "$file2:"
        cat "$file2"
    elif [[ ! -f "$file1" ]] && [[ ! -f "$file2" ]]; then
        rstring1=$(openssl rand -base64 8)
        rstring2=$(openssl rand -base64 8)
        echo $rstring1 | base64 -d > "$file1"
        echo $rstring2 | base64 -d > "$file2"
        chmod 700 "$file1" "$file2"
        echo "new files: $file1, $file2"
    elif [[ ! -f "$file1" ]]; then
        rstring1=$(openssl rand -base64 8)
        echo $rstring1 | base64 -d > "$file1"
        chmod 700 "$file1"
        echo "new file: $file1"
        echo "$file2:"
        cat "$file2"
    else
        echo "$file1:"
        cat "$file1"
        rstring2=$(openssl rand -base64 8)
        echo $rstring2 | base64 -d > "$file2"
        chmod 700 "$file2"
        echo "new file: $file2"
    fi

else
    echo "Enter two arguments"
    exit 1
fi
