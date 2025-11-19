#!/usr/bin/env bash
echo "Post create script running..."

# Create AWS config folders
mkdir -p ~/.aws

# install git lfs

sudo apt-get update -y
sudo apt-get install -y git-lfs
git lfs install


# Instructions to user
cat << 'EOF'

=======================================================
 AWS CLI NO ESTA CONFIGURADO AUN
=======================================================
Antes de usar AWS, ejecuta:

    aws configure

Y coloca:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    region: us-east-1
    format: json

Para probar conexión:

    aws sts get-caller-identity

=======================================================
EOF
