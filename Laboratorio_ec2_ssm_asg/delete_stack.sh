
#!/bin/bash
# Script para eliminar el stack de CloudFormation y esperar hasta su eliminación completa

STACK_NAME="gabriel-stack"
REGION="us-east-1"
PROFILE="default"

echo "Solicitando eliminación del stack $STACK_NAME..."
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION \
  --profile $PROFILE

echo "Esperando a que el stack $STACK_NAME sea eliminado..."
while true; do
  STATUS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --profile $PROFILE 2>&1)
  if echo "$STATUS" | grep -q "does not exist"; then
    echo "Stack $STACK_NAME eliminado correctamente."
    break
  elif echo "$STATUS" | grep -q "DELETE_IN_PROGRESS"; then
    echo "Eliminación en progreso..."
  else
    echo "Estado actual: $STATUS"
  fi
  sleep 5
done
