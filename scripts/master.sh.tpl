#!/bin/bash
set -euxo pipefail

# Log everything
exec > >(tee /var/log/user-data.log)
exec 2>&1

#############################################
# Basic System Configuration
#############################################

hostnamectl set-hostname ${hostname}

export AWS_DEFAULT_REGION="${aws_region}"

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

apt-get update -y
apt-get install -y \
    curl \
    unzip \
    ca-certificates \
    apt-transport-https \
    gpg \
    git

#############################################
# Clone Repository
#############################################

cd /opt

git clone https://github.com/vijayvw/k8s-cluster-automation.git

cd k8s-cluster-automation

#############################################
# Install Components
#############################################

bash scripts/install/01-awscli.sh

bash scripts/install/02-containerd.sh

bash scripts/install/03-kubernetes.sh

bash scripts/install/04-master-init.sh \
    "${hostname}" \
    "${aws_region}" \
    "${ssh_user}"

bash scripts/install/06-cni.sh

bash scripts/install/07-helm.sh

bash scripts/install/08-ingress.sh

bash scripts/install/09-cert-manager.sh

bash scripts/install/10-monitoring.sh

bash scripts/install/11-argocd.sh

bash scripts/install/12-local-path-storage.sh

bash scripts/install/13-external-secrets.sh 

bash /opt/k8s-cluster-automation/scripts/install/14-metrics-server.sh

#############################################
# Cluster Status
#############################################

echo
echo "========== Kubernetes Nodes =========="
kubectl get nodes

echo
echo "========== All Pods =========="
kubectl get pods -A

echo
echo "========== Ingress =========="
kubectl get svc -n ingress-nginx

echo
echo "========== Cert Manager =========="
kubectl get pods -n cert-manager

echo
echo "========== Monitoring =========="
kubectl get pods -n monitoring

echo
echo "========== Argo CD =========="
kubectl get pods -n argocd

echo
echo "==========================================="
echo " Kubernetes Master Setup Completed"
echo "==========================================="
echo
