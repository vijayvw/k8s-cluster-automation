#!/bin/bash
set -e

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "======================================"
echo "Installing Metrics Server..."
echo "======================================"

kubectl apply -f /opt/k8s-cluster-automation/scripts/manifests/metrics-server.yaml

echo
echo "Waiting for Metrics Server Deployment..."

kubectl rollout status deployment/metrics-server \
  -n kube-system \
  --timeout=180s

echo
echo "Waiting for Metrics API..."

until kubectl top nodes >/dev/null 2>&1; do
    echo "Metrics API not ready yet..."
    sleep 5
done

echo
echo "Verifying Metrics Server..."

kubectl get deployment metrics-server -n kube-system

kubectl get pods -n kube-system -l k8s-app=metrics-server

echo
echo "Node Metrics:"
kubectl top nodes

echo
echo "Pod Metrics:"
kubectl top pods -A

echo
echo "======================================"
echo "Metrics Server installed successfully."
echo "======================================"
