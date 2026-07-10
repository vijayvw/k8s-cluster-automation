#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing cert-manager"
echo "==========================================="

#############################################
# Add Helm Repository
#############################################

helm repo add jetstack https://charts.jetstack.io

helm repo update

#############################################
# Install cert-manager
#############################################

helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --set crds.enabled=true

#############################################
# Wait for cert-manager
#############################################

echo "Waiting for cert-manager..."

kubectl wait \
    --namespace cert-manager \
    --for=condition=Ready pod \
    --all \
    --timeout=300s

#############################################
# Verify Installation
#############################################

kubectl get pods -n cert-manager

echo
echo "cert-manager Installed Successfully."
echo
