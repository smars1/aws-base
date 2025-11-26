#!/bin/bash
# Improved delete script (keeps original delete_stack.sh untouched)
# Usage: STACK_NAME=your-stack SSM_PREFIX=/your/prefix ./scripts/delete_stack.sh

STACK_NAME="${STACK_NAME:-gabriel-stack}"
REGION="${REGION:-us-east-1}"
PROFILE="${PROFILE:-default}"
SSM_PREFIX="${SSM_PREFIX:-/gabriel}"

set -euo pipefail

echo "Deleting CloudFormation stack: $STACK_NAME (region=$REGION, profile=$PROFILE)"
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION" --profile "$PROFILE" || true

echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" --region "$REGION" --profile "$PROFILE" || true

echo "Deleting SSM parameters under prefix: $SSM_PREFIX"
# List parameters under prefix and delete them in batches
PARAMS=$(aws ssm get-parameters-by-path --path "$SSM_PREFIX" --recursive --region "$REGION" --profile "$PROFILE" --query 'Parameters[].Name' --output text 2>/dev/null || true)
if [ -n "$PARAMS" ]; then
  echo "$PARAMS" | xargs -n 10 | while read -r batch; do
    aws ssm delete-parameters --names $batch --region "$REGION" --profile "$PROFILE" || true
  done
  echo "SSM parameters deleted (if existed)."
else
  echo "No SSM parameters found under $SSM_PREFIX"
fi

echo "Cleanup complete." 
