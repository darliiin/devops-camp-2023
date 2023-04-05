#!/bin/bash

# list of kubernetes namespaces that are not backed up

# download velero backup
VELERO_BACKUP_URL=$(curl -sSL https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml)

# list of kubernetes namespaces backed up
ARR_BACKUP=($(echo "$VELERO_BACKUP_URL" | yq eval '.spec.source.helm.values' | yq eval '.schedules.system.template.includedNamespaces[]'))

# download kubernetes namespaces
ARR_NAMESPACES=($(curl -sSL https://gist.github.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt))

# list of kubernetes namespaces that are not backed up
for str in "${ARR_NAMESPACES[@]}"; do
  if ! [[ "${ARR_BACKUP[@]}" =~ "$str" ]] ; then
    echo "$str"
  fi
done
