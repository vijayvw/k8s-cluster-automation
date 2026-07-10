#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log)
exec 2>&1

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

bash scripts/install/05-worker-join.sh \
    "${hostname}" \
    "${aws_region}"

echo
echo "==========================================="
echo " Worker Successfully Joined Kubernetes"
echo "==========================================="
echo
