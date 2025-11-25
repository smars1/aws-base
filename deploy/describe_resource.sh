#!/usr/bin/env bash
# deploy_ec2_ssm.sh
# Script to deploy EC2 via CloudFormation using SSM, reading vars from .env

set -e

ENV_FILE=".env"

if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

VPC_ID="${VPC_ID:-}"
SUBNET_ID="${SUBNET_ID:-}"
USERNAME="${USERNAME:-}"
ENVNAME="${ENVNAME:-}"
TEMPLATE_FILE="${TEMPLATE_FILE:-}"
echo -e "VPC_ID: $VPC_ID"
echo -e "SUBNET_ID: $SUBNET_ID"
echo -e "USERNAME: $USERNAME"
echo -e "ENVNAME: $ENVNAME"
echo -e "TEMPLATE_FILE: $TEMPLATE_FILE"  

if [[ -z "$VPC_ID" ]]; then
    read -p "Enter VPC ID: " VPC_ID
fi
if [[ -z "$SUBNET_ID" ]]; then
    read -p "Enter Subnet ID: " SUBNET_ID
fi
if [[ -z "$USERNAME" ]]; then
    read -p "Enter Student ID: " USERNAME
fi
if [[ -z "$TEMPLATE_FILE" ]]; then
    read -p "Enter template file name: " TEMPLATE_FILE
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Template file not found: $TEMPLATE_FILE"
    exit 1
fi

STACK_NAME="ec2-lab-${ENVNAME}-${USERNAME}"
echo -e "Deploying stack: $STACK_NAME using template: $TEMPLATE_FILE"


STACK_NAME="ec2-lab-${ENVNAME}-${USERTNAME}"

aws cloudformation describe-stack-resources \
  --stack-name $STACK_NAME \
  --region us-east-1 \
  --profile default