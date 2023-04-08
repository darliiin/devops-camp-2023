#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "You must specify one folder"
    exit 1
fi

arr=()

for file in $(find $1 -type f); do
    if [[ $file == *.* && ! "${arr[@]}" =~ ${file/*./} ]]; then
        arr+=${file/*./}
        echo ${file/*./}
    fi
done

# echo ${arr[@]}

