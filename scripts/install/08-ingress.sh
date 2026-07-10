#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing NGINX Ingress Controller"
echo "==========================================="

#############################################
# Add Helm Repository
#############################################

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

#############################################
# Install NGINX Ingress Controller
#############################################

helm upgrade --install ingress-nginx \
  ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  -f helm-values/ingress-nginx-values.yaml

#############################################
# Wait for Controller
#############################################

echo "Waiting for NGINX Ingress Controller..."

kubectl wait \
    --namespace ingress-nginx \
    --for=condition=Ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=300s

#############################################
# Verify Installation
#############################################

kubectl get pods -n ingress-nginx

kubectl get svc -n ingress-nginx

echo
echo "NGINX Ingress Controller Installed Successfully."
echo
