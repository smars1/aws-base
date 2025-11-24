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
ENVNAME="${ENVNAME:-dev}"
TEMPLATE_FILE="${TEMPLATE_FILE:-template.yml}"
AMI_ID="${AMI_ID:-ami-0ecb62995f68bb549}"

echo -e "VPC_ID: $VPC_ID"
echo -e "SUBNET_ID: $SUBNET_ID"
echo -e "USERNAME: $USERNAME"
echo -e "ENVNAME: $ENVNAME"
echo -e "TEMPLATE_FILE: $TEMPLATE_FILE"
echo -e "AMI_ID: $AMI_ID"

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

aws cloudformation deploy \
   --template-file "$TEMPLATE_FILE" \
   --stack-name "$STACK_NAME" \
   --parameter-overrides \
      UserName="$USERNAME" \
      VpcId="$VPC_ID" \
      SubnetId="$SUBNET_ID" \
      EnvName="$ENVNAME" \
      AmiId="$AMI_ID" \
   --capabilities CAPABILITY_NAMED_IAM

echo "Deployment initiated for stack: $STACK_NAME"
echo ""
echo "To connect via SSM:"
echo ""
echo "aws ssm start-session --target \$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==\`MyEC2InstanceId\`].OutputValue' --output text)"
