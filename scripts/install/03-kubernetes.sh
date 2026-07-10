#!/bin/bash

set -euxo pipefail

echo "==========================================="
echo " Installing Kubernetes"
echo "==========================================="

#############################################
# Add Kubernetes Repository
#############################################

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
| gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
> /etc/apt/sources.list.d/kubernetes.list

#############################################
# Install Kubernetes Packages
#############################################

apt-get update -y

apt-get install -y \
    kubelet \
    kubeadm \
    kubectl

apt-mark hold \
    kubelet \
    kubeadm \
    kubectl

#############################################
# Enable kubelet
#############################################

systemctl enable kubelet
systemctl start kubelet

kubeadm version
kubectl version --client
kubelet --version

echo
echo "Kubernetes Installed Successfully."
echo
