# Laboratorio: Despliegue de EC2 con ALB usando CloudFormation y SSM

Objetivo
--------
Crear una infraestructura mínima en AWS con una instancia EC2 (Apache + PHP) detrás de un Application Load Balancer (ALB). Aprender a usar CloudFormation junto con AWS Systems Manager Parameter Store para gestionar parámetros sin hardcode.

Requisitos
---------
- AWS CLI configurado con un perfil que tenga permisos para CloudFormation, EC2, ELBv2, IAM y SSM.
- Python 3 para ejecutar el script de creación de parámetros SSM.

Convenciones y prevención de conflictos
-------------------------------------
Todos los participantes usarán un prefijo SSM y un nombre de stack personalizado para evitar colisiones en la misma cuenta.

- Prefix SSM: `/labs/<username>` (ejemplo: `/labs/gabriel`)
- Stack name: `lab-<username>-stack` (ejemplo: `lab-gabriel-stack`)

Pasos del laboratorio
---------------------

1. Preparar parámetros en SSM (recomendado)

```bash
# ejemplo para el alumno 'alice'
SSM_PREFIX=/labs/alice
python3 scripts/create_ssm_params.py --template infra.yml --prefix "$SSM_PREFIX" --region us-east-1 --profile default
```

Esto creará parámetros como `/labs/alice/VpcId`, `/labs/alice/Subnet1`, etc.

2. Desplegar la plantilla usando los parámetros SSM

```bash
STACK_NAME=lab-alice-stack SSM_PREFIX=/labs/alice ./create_stack.sh
```

El script consultará SSM para cada parámetro y usará valores por defecto si no están en SSM.

3. Verificar outputs y validar la aplicación

```bash
aws cloudformation describe-stacks --stack-name $STACK_NAME --region us-east-1 --profile default --query "Stacks[0].Outputs" --output table

# Obtener DNS del ALB y probar
ALB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region us-east-1 --profile default --query "Stacks[0].Outputs[?OutputKey=='AlbDNSName'].OutputValue" --output text)
curl -sL "http://$ALB_DNS/" | sed -n '1,120p'
```

4. Limpieza (importante para evitar cargos)

```bash
# Borrar stack y parámetros SSM asociados
STACK_NAME=lab-alice-stack SSM_PREFIX=/labs/alice ./scripts/delete_stack.sh
```

Notas
-----
- El script `create_ssm_params.py` sobrescribirá parámetros SSM existentes con el Default definido en `infra.yml`.
- Si hay recursos compartidos entre alumnos (por ejemplo VPCs públicas prefijadas) acuerden identificadores únicos.
- Para mayor seguridad, considera usar `SecureString` para valores sensibles y un KMS key por equipo.
