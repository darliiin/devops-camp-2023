#!/bin/bash

# list of kubernetes namespaces that are not backed up

# download velero backup
VELERO_BACKUP_NAMESPACES=$(curl -sSL https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml)

# check for file velero.yaml existence
if [[ "$VELERO_BACKUP_NAMESPACES" == "404: Not Found"  ]]; then
  echo "ERROR: file velero.yaml not loaded"
  exit 1
fi

# list of kubernetes namespaces backed up
VELERO_MANIFEST=($(echo "$VELERO_BACKUP_NAMESPACES" | yq ".spec.source.helm.values" \
  | yq ".schedules[].template.includedNamespaces[]" | sort ))

# download kubernetes namespaces
KUBERNETES_NAMESPACES=($(curl -sSL https://gist.github.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt))

# check for file namespaces.txt existence
if [[ $KUBERNETES_NAMESPACES == *"404:"* ]]; then
  echo "ERROR: file kubernetes-namespaces.txt not loaded"
  exit 1
fi

# list of kubernetes namespaces that are not backed up
for namespace in "${KUBERNETES_NAMESPACES[@]}"; do
  if ! [[ " ${VELERO_MANIFEST[@]} " =~ " ${namespace} " ]] ; then
    echo "$namespace"
  fi

done
