#!/usr/bin/env bash
echo "========================================"
echo "  AWS Credential Setup for Codespaces"
echo "========================================"
echo ""

# Cargar .env si existe
if [ -f .env ]; then
    echo " Detectado archivo .env — cargando variables..."
    export $(grep -v '^#' .env | xargs)
else
    echo " No se encontró .env — se pedirá manualmente."
fi

# Si no hay variables, pedirlas al alumno
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    read -p "AWS Access Key ID: " AWS_ACCESS_KEY_ID
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    read -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
fi

if [ -z "$AWS_REGION" ]; then
    read -p "Default Region [us-east-1]: " AWS_REGION
    AWS_REGION=${AWS_REGION:-us-east-1}
fi

echo ""
echo "🚀 Configurando AWS CLI..."

# Crear carpeta si no existe
mkdir -p ~/.aws

# Configurar credenciales
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile default
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile default
aws configure set region "$AWS_REGION" --profile default
aws configure set output json --profile default

echo ""
echo "========================================"
echo "  Configuración completada"
echo "========================================"
echo ""
echo "Puedes probar con:"
echo "    aws sts get-caller-identity"
echo ""
