#!/bin/bash
set -e

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "Installing External Secrets Operator..."

helm repo add external-secrets https://charts.external-secrets.io

helm repo update

kubectl create namespace external-secrets --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets

echo "Waiting for External Secrets Controller..."

kubectl rollout status deployment/external-secrets \
  -n external-secrets \
  --timeout=180s

echo "Waiting for External Secrets Webhook..."

kubectl rollout status deployment/external-secrets-webhook \
  -n external-secrets \
  --timeout=180s

echo "Waiting for External Secrets Cert Controller..."

kubectl rollout status deployment/external-secrets-cert-controller \
  -n external-secrets \
  --timeout=180s

echo "Creating ClusterSecretStore..."

kubectl apply -f /opt/k8s-cluster-automation/scripts/manifests/cluster-secret-store.yaml

echo "External Secrets Operator installed successfully."
