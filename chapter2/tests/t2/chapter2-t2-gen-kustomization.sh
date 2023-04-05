#!/bin/bash

# checking for the number of passed arguments
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided."
    exit 1
fi

KEYS_PATH="repos"
KUSTOMIZATION_PATH="$KEYS_PATH/kustomization.yaml"

if [ ! -d "$KEYS_PATH" ]; then
  mkdir "$KEYS_PATH"
fi

# clearing the file before writing
txt0="apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:"

echo "$txt0" > "$KUSTOMIZATION_PATH"

# Loop through all repository names
for repo_name in "$@"
do
  # Generate SSH key
  echo y | ssh-keygen -t ed25519 -f $KEYS_PATH/"${repo_name}"-deploy-key.pem -N "" -q

# Generate kustomization.yaml file
txt="
  - name: ${repo_name}
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: repository
    literals:
      - name=${repo_name}
      - url=git@github.com:saritasa-nest/${repo_name}.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=${repo_name}-deploy-key.pem"

cat << EOF >> $KUSTOMIZATION_PATH
$txt
EOF

done

kustomize build "$KEYS_PATH"
