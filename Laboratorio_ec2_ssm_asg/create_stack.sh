#!/bin/bash
# Script para crear o actualizar el stack de CloudFormation de forma parametrizada



#!/bin/bash
# Script para crear o actualizar el stack de CloudFormation con parámetros dinámicos

# ============================================================
# 1. CARGAR VARIABLES DESDE .env
# ============================================================

if [ -f .env ]; then
  echo "[INFO] Cargando variables desde .env..."
  export $(grep -v '^#' .env | xargs)
else
  echo "[WARN] No se encontró .env — se usarán valores de entorno o defaults."
fi

# ============================================================
# 2. VARIABLES BASE (pueden ser sobrescritas por .env)
# ============================================================

STACK_NAME="${STACK_NAME:-gabriel-stack}"
TEMPLATE_FILE="${TEMPLATE_FILE:-infra.yml}"
REGION="${REGION:-us-east-1}"
PROFILE="${PROFILE:-default}"
SSM_PREFIX="${SSM_PREFIX:-/gabriel}"


# Parámetros: intentaremos obtenerlos de SSM Parameter Store bajo /gabriel/<ParameterName>
# Override SSM_PREFIX from environment or use default defined above
# SSM_PREFIX="$SSM_PREFIX"

# Hardcoded defaults (se usan si SSM no devuelve valor)
VPC_ID="vpc-077036bfcbb11d434"
SUBNET_ID="subnet-0768550a08edf7c74"
INSTANCE_TYPE="t3.micro"
INSTANCE_NAME="gabriel"
SECURITY_GROUP_ID="sg-08fd9307f7c135213"
LAUNCH_TEMPLATE_NAME="lt-gabriel"
AUTOSCALING_GROUP_NAME="asg-gabriel"
SUBNET1="subnet-0768550a08edf7c74"
SUBNET2="subnet-021f2eade5dd37c7c"
TAG_NAME="Web Server - Gabriel"
LATEST_AMI_ID="ami-052064a798f08f0d3"
MIN_SIZE="2"
DESIRED_CAPACITY="2"
MAX_SIZE="2"

# Helper to get SSM parameter or fallback
get_ssm_or_default() {
  local name="$1"
  local fallback="$2"
  local val
  val=$(aws ssm get-parameter --name "$SSM_PREFIX/$name" --region $REGION --profile $PROFILE --query 'Parameter.Value' --output text 2>/dev/null || true)
  if [ -z "$val" ] || [ "$val" = "None" ]; then
    echo "$fallback"
  else
    echo "$val"
  fi
}

# Populate variables from SSM (with fallbacks)
VPC_ID=$(get_ssm_or_default VpcId "$VPC_ID")
SUBNET_ID=$(get_ssm_or_default SubnetId "$SUBNET_ID")
INSTANCE_TYPE=$(get_ssm_or_default InstanceType "$INSTANCE_TYPE")
INSTANCE_NAME=$(get_ssm_or_default InstanceName "$INSTANCE_NAME")
SECURITY_GROUP_ID=$(get_ssm_or_default SecurityGroupId "$SECURITY_GROUP_ID")
LAUNCH_TEMPLATE_NAME=$(get_ssm_or_default LaunchTemplateName "$LAUNCH_TEMPLATE_NAME")
AUTOSCALING_GROUP_NAME=$(get_ssm_or_default AutoScalingGroupName "$AUTOSCALING_GROUP_NAME")
SUBNET1=$(get_ssm_or_default Subnet1 "$SUBNET1")
SUBNET2=$(get_ssm_or_default Subnet2 "$SUBNET2")
TAG_NAME=$(get_ssm_or_default TagName "$TAG_NAME")
LATEST_AMI_ID=$(get_ssm_or_default LatestAmiId "$LATEST_AMI_ID")
MIN_SIZE=$(get_ssm_or_default MinSize "$MIN_SIZE")
DESIRED_CAPACITY=$(get_ssm_or_default DesiredCapacity "$DESIRED_CAPACITY")
MAX_SIZE=$(get_ssm_or_default MaxSize "$MAX_SIZE")

# Mostrar valores que se usarán
echo "Using stack name: $STACK_NAME"
echo "SSM prefix: $SSM_PREFIX"
echo "Region: $REGION, Profile: $PROFILE"

# Construir la cadena de parámetros para CloudFormation
PARAMETERS=(
  ParameterKey=VpcId,ParameterValue=$VPC_ID
  ParameterKey=SubnetId,ParameterValue=$SUBNET_ID
  ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE
  ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME
  ParameterKey=SecurityGroupId,ParameterValue=$SECURITY_GROUP_ID
  ParameterKey=LaunchTemplateName,ParameterValue=$LAUNCH_TEMPLATE_NAME
  ParameterKey=AutoScalingGroupName,ParameterValue=$AUTOSCALING_GROUP_NAME
  ParameterKey=Subnet1,ParameterValue=$SUBNET1
  ParameterKey=Subnet2,ParameterValue=$SUBNET2
  ParameterKey=TagName,ParameterValue="$TAG_NAME"
  ParameterKey=LatestAmiId,ParameterValue=$LATEST_AMI_ID
  ParameterKey=MinSize,ParameterValue=$MIN_SIZE
  ParameterKey=MaxSize,ParameterValue=$MAX_SIZE
  ParameterKey=DesiredCapacity,ParameterValue=$DESIRED_CAPACITY
)

echo "Verificando si el stack $STACK_NAME existe..."
aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --profile $PROFILE &> /dev/null
if [ $? -eq 0 ]; then
  echo "Actualizando el stack $STACK_NAME..."
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION \
    --profile $PROFILE \
    --parameters "${PARAMETERS[@]}"
else
  echo "Creando el stack $STACK_NAME..."
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION \
    --profile $PROFILE \
    --parameters "${PARAMETERS[@]}"
fi
