#!/bin/bash

set -euxo pipefail

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "==========================================="
echo " Installing Prometheus + Grafana"
echo "==========================================="

#############################################
# Add Helm Repository
#############################################

helm repo add prometheus-community \
    https://prometheus-community.github.io/helm-charts

helm repo update

#############################################
# Install kube-prometheus-stack
#############################################

helm upgrade --install kube-prometheus-stack \
    prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --create-namespace \
    -f helm-values/monitoring-values.yaml 

#############################################
# Wait for Prometheus Operator
#############################################

echo "Waiting for Prometheus Operator..."

kubectl rollout status \
    deployment/kube-prometheus-stack-operator \
    -n monitoring \
    --timeout=600s

#############################################
# Wait for Grafana
#############################################

echo "Waiting for Grafana..."

kubectl wait \
    --namespace monitoring \
    --for=condition=Ready pod \
    --selector=app.kubernetes.io/name=grafana \
    --timeout=600s

#############################################
# Verify Installation
#############################################

kubectl get pods -n monitoring

kubectl get svc -n monitoring

echo
echo "Monitoring Stack Installed Successfully."
echo
