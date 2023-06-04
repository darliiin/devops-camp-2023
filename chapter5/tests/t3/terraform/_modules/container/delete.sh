#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
folder="${SCRIPT_DIR}/../../../dev"

if [ -d "${folder}" ]; then
  sudo rm -rf "${folder}"
fi
