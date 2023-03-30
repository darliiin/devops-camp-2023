#!/bin/bash
#generating ssh keys for passed repositories, generating repos/customization.yaml
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided."
    exit 1
fi

if [ ! -d "repos" ]; then
  mkdir repos
fi

# Loop through all repository names
for repo_name in "$@"
do
  # Generate SSH key
  ssh-keygen -y -t ed25519 -f repos/"${repo_name}-deploy-key.pem" -N "" -q

# Generate kustomization.yaml file
txt="apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
generatorOptions:
  disableNameSuffixHash: true
secretGenerator:
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

echo "$txt" > repos/kustomization.yaml

kustomize build repos

done


