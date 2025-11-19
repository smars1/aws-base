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
STUDENT_ID="${STUDENT_ID:-}"
TEMPLATE_FILE="${TEMPLATE_FILE:-}"

if [[ -z "$VPC_ID" ]]; then
    read -p "Enter VPC ID: " VPC_ID
fi
if [[ -z "$SUBNET_ID" ]]; then
    read -p "Enter Subnet ID: " SUBNET_ID
fi
if [[ -z "$STUDENT_ID" ]]; then
    read -p "Enter Student ID: " STUDENT_ID
fi
if [[ -z "$TEMPLATE_FILE" ]]; then
    read -p "Enter template file name: " TEMPLATE_FILE
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Template file not found: $TEMPLATE_FILE"
    exit 1
fi

STACK_NAME="ec2-lab-${STUDENT_ID}"

aws cloudformation deploy  \
   --stack-name "$STACK_NAME" \
   --template-file "$TEMPLATE_FILE" \
   --parameter-overrides VpcId="$VPC_ID" \
    SubnetId="$SUBNET_ID" \
    StudentId="$STUDENT_ID" \
    --capabilities CAPABILITY_NAMED_IAM

echo "To connect:"
echo "aws ssm start-session --target \$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='InstanceId'].OutputValue" --output text)"
