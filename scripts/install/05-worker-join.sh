#!/bin/bash

set -euxo pipefail

AWS_REGION="$2"

export AWS_DEFAULT_REGION="$AWS_REGION"

echo "==========================================="
echo " Joining Kubernetes Cluster"
echo "==========================================="

#############################################
# Wait for Kubernetes Join Command
#############################################

echo "Waiting for Kubernetes join command..."

MAX_RETRIES=80
RETRY=0

while true; do
    JOIN_COMMAND=$(aws ssm get-parameter \
        --name "/k8s/join-command" \
        --with-decryption \
        --query "Parameter.Value" \
        --output text 2>/dev/null || true)

    if [[ -n "$JOIN_COMMAND" && "$JOIN_COMMAND" != "pending" ]]; then
        break
    fi

    RETRY=$((RETRY + 1))

    if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
        echo "Timed out waiting for join command"
        exit 1
    fi

    echo "Join command not ready yet..."
    sleep 15
done

#############################################
# Join Cluster
#############################################

echo "Joining Kubernetes Cluster..."

echo "$JOIN_COMMAND"

eval "$JOIN_COMMAND"

#############################################
# Verify Join
#############################################

echo "Waiting for kubelet to register..."

sleep 15

systemctl status kubelet --no-pager

echo
echo "==========================================="
echo " Worker Successfully Joined Kubernetes"
echo "==========================================="
echo
