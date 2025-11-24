#!/usr/bin/env bash

set -e

ENV_FILE=".env"

if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

USERNAME="${USERNAME:-}"
ENVNAME="${ENVNAME:-dev}"

STACK_NAME="ec2-lab-${USERNAME}-${ENVNAME}"
ROLE_NAME="ec2-ssm-role-${ENVNAME}-${USERNAME}"

echo "Eliminando stack $STACK_NAME ..."
aws cloudformation delete-stack \
   --stack-name "$STACK_NAME" \
   --region us-east-1

aws cloudformation wait stack-delete-complete \
   --stack-name "$STACK_NAME" \
   --region us-east-1 || true

echo "Stack eliminado"

# Delete instance profile
PROFILE_NAME=$(aws iam list-instance-profiles \
  --query "InstanceProfiles[?contains(InstanceProfileName, '${USERNAME}')].InstanceProfileName" \
  --output text)

if [[ "$PROFILE_NAME" != "None" && "$PROFILE_NAME" != "" ]]; then
    echo "Eliminando InstanceProfile: $PROFILE_NAME"
    aws iam remove-role-from-instance-profile \
        --instance-profile-name "$PROFILE_NAME" \
        --role-name "$ROLE_NAME" || true

    aws iam delete-instance-profile \
        --instance-profile-name "$PROFILE_NAME" || true
fi

# Delete role
if aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
    echo "Eliminando Role: $ROLE_NAME"
    aws iam delete-role --role-name "$ROLE_NAME" || true
fi

echo "Rollback COMPLETO"
