#!/bin/bash

set -euxo pipefail
export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing Weave Net CNI"
echo "==========================================="

#############################################
# Install Weave Net
#############################################

kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.29/net.yaml

#############################################
# Wait for Node Ready
#############################################

echo "Waiting for CNI to become Ready..."

kubectl wait \
    --for=condition=Ready \
    node/"$(hostname)" \
    --timeout=300s

echo
echo "Weave Net Installed Successfully."
echo
