#!/bin/bash
set -euxo pipefail

#############################################
# Install AWS CLI
#############################################

ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        AWS_ARCH="x86_64"
        ;;
    aarch64)
        AWS_ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
    -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

rm -rf /tmp/aws /tmp/awscliv2.zip

aws --version

echo
echo "AWS CLI Installed Successfully."
echo
