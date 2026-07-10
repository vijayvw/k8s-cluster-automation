#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing Helm"
echo "==========================================="

#############################################
# Install Helm
#############################################

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    | bash

#############################################
# Verify Installation
#############################################

helm version

echo
echo "Helm Installed Successfully."
echo
