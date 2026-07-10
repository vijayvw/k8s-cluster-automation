#!/bin/bash

set -euxo pipefail

#############################################
# Load Kernel Modules
#############################################

cat <<EOF >/etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

#############################################
# Configure Kernel Parameters
#############################################

cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
echo "==========================================="
echo " Installing Containerd"
echo "==========================================="

#############################################
# Add Docker Repository
#############################################

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
> /etc/apt/sources.list.d/docker.list

#############################################
# Install Containerd
#############################################

apt-get update -y

apt-get install -y containerd.io

#############################################
# Configure Containerd
#############################################

mkdir -p /etc/containerd

containerd config default >/etc/containerd/config.toml

sed -i \
's/SystemdCgroup = false/SystemdCgroup = true/' \
/etc/containerd/config.toml

#############################################
# Enable Containerd
#############################################

systemctl enable containerd
systemctl restart containerd

systemctl status containerd --no-pager

echo
echo "Containerd Installed Successfully."
echo
