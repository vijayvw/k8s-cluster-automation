#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

LOCAL_PATH_VERSION="v0.0.32"

echo "==========================================="
echo " Installing Local Path Provisioner"
echo "==========================================="

#############################################
# Install Local Path Provisioner
#############################################

kubectl apply -f "https://raw.githubusercontent.com/rancher/local-path-provisioner/${LOCAL_PATH_VERSION}/deploy/local-path-storage.yaml"

#############################################
# Wait for Deployment
#############################################

echo "Waiting for Local Path Provisioner..."

kubectl wait \
  --namespace local-path-storage \
  --for=condition=Available deployment/local-path-provisioner \
  --timeout=300s

#############################################
# Make StorageClass Default
#############################################

kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

#############################################
# Verify Installation
#############################################

kubectl get storageclass

kubectl get pods -n local-path-storage

echo
echo "==========================================="
echo " Local Path Provisioner Installed Successfully"
echo "==========================================="
echo
