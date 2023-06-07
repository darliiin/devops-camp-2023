#!/bin/bash

# deleting folder with generated html file
SCRIPT_DIR="$(dirname "$0")"
folder = "dev"

path="${SCRIPT_DIR}/../../../${folder}"

if [ -d "${path}" ]; then
  sudo rm -rf "${path}"
fi
