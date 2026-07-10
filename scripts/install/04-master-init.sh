#!/bin/bash

set -euxo pipefail

HOSTNAME="$1"
AWS_REGION="$2"
SSH_USER="$3"

export AWS_DEFAULT_REGION="$AWS_REGION"

echo "==========================================="
echo " Initializing Kubernetes Control Plane"
echo "==========================================="

#############################################
# Initialize Kubernetes Control Plane
#############################################

MASTER_IP=$(hostname -I | awk '{print $1}')

kubeadm init \
    --apiserver-advertise-address="$MASTER_IP"

#############################################
# Configure kubectl for root
#############################################

mkdir -p /root/.kube

cp /etc/kubernetes/admin.conf /root/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

#############################################
# Configure kubectl for SSH User
#############################################

mkdir -p /home/$SSH_USER/.kube

cp /etc/kubernetes/admin.conf \
    /home/$SSH_USER/.kube/config

chown -R "$SSH_USER:$SSH_USER" \
    /home/$SSH_USER/.kube

#############################################
# Wait for API Server
#############################################

echo "Waiting for Kubernetes API Server..."

until kubectl get --raw='/readyz' >/dev/null 2>&1
do
    sleep 5
done

echo "API Server is Ready."

#############################################
# Generate Join Command
#############################################

echo "Generating Kubernetes Join Command..."

JOIN_COMMAND=$(kubeadm token create --print-join-command)

#############################################
# Store Join Command in AWS SSM
#############################################

aws ssm put-parameter \
    --name "/k8s/join-command" \
    --value "$JOIN_COMMAND" \
    --type SecureString \
    --overwrite

echo
echo "Join command stored successfully."
echo

echo
echo "Kubernetes Control Plane Initialized Successfully."
echo
