#!/bin/bash

# function to check if a file was loaded or not
function check_file() {
  local name_file=$1
  local file=$2
  if [[ "$file" == *"404:"* ]]; then
    echo "ERROR: file $name_file not found "
    exit 1
  fi
}

# download velero backup
VELERO_BACKUP=$(curl -sSL https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml)

check_file "velero.yaml" "${VELERO_BACKUP}"

# list of kubernetes namespaces backed up
VELERO_NAMESPACES=$(echo "$VELERO_BACKUP" | yq ".spec.source.helm.values" \
  | yq ".schedules[].template.includedNamespaces[]" | sort )

# list of actual kubernetes namespaces
KUBERNETES_NAMESPACES=$(curl -sSL https://gist.github.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt)

check_file "kubernetes-namespaces.txt" "${KUBERNETES_NAMESPACES}"

# list of kubernetes namespaces that are not backed up
sort <<< "$VELERO_NAMESPACES"$'\n'"$KUBERNETES_NAMESPACES" | uniq -u
