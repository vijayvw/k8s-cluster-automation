#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing Argo CD"
echo "==========================================="

#############################################
# Create Namespace
#############################################

kubectl create namespace argocd \
    --dry-run=client \
    -o yaml | kubectl apply -f -

#############################################
# Install Argo CD
#############################################

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f helm-values/argocd-values.yaml 

#############################################
# Wait for Argo CD
#############################################

echo "Waiting for Argo CD..."

kubectl wait \
    --namespace argocd \
    --for=condition=Available deployment \
    --all \
    --timeout=600s

#############################################
# Verify Installation
#############################################

kubectl get pods -n argocd

kubectl get svc -n argocd

echo
echo "Argo CD Installed Successfully."
echo
