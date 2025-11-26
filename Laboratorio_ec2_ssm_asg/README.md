# Despliegue con AWS CloudFormation


## Despliegue y actualización de la infraestructura

Para crear o actualizar la infraestructura definida en `infra.yml`, utiliza el script parametrizado:

```bash
./create_stack.sh
```

El script detecta automáticamente si el stack existe y realiza una actualización (`update-stack`) o una creación (`create-stack`) según corresponda.

### Personalización de parámetros
Puedes modificar los valores de los parámetros directamente en el script `create_stack.sh` para adaptarlos a tu entorno:

- VPC_ID
- SUBNET_ID
- INSTANCE_TYPE
- INSTANCE_NAME
- SECURITY_GROUP_ID
- LAUNCH_TEMPLATE_NAME
- AUTOSCALING_GROUP_NAME
- SUBNET1
- SUBNET2
- TAG_NAME
- LATEST_AMI_ID

### Requisitos previos
- Tener configurado el AWS CLI y las credenciales necesarias (ej: `aws configure`).
- Permisos para crear y actualizar recursos en AWS CloudFormation, crear SSM Parameters y gestionar EC2/ELB/IAM.

## Quickstart (recomendado para laboratorios)

1) Elegir un identificador único para evitar colisiones en la misma cuenta (por ejemplo tu nombre de usuario):

```bash
USER=miusuario
STACK_NAME=lab-${USER}-stack
SSM_PREFIX=/labs/${USER}
```

2) Poblar SSM Parameter Store (opcional, facilita la configuración):

```bash
python3 scripts/create_ssm_params.py --template infra.yml --prefix "$SSM_PREFIX" --region us-east-1 --profile default
```

El script creará parámetros como `/labs/miusuario/VpcId`, `/labs/miusuario/Subnet1`, etc. Si algunos valores se dejaron vacíos en `infra.yml` (por diseño) tendrás que completar manualmente esos parámetros en SSM o pasar overrides al script.

3) Desplegar la plantilla (leerá parámetros desde SSM si existen):

```bash
STACK_NAME="$STACK_NAME" SSM_PREFIX="$SSM_PREFIX" chmod +x create_stack.sh && ./create_stack.sh
```

4) Obtener outputs y validar la aplicación:

```bash
aws cloudformation describe-stacks --stack-name $STACK_NAME --region us-east-1 --profile default --query "Stacks[0].Outputs" --output table
ALB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region us-east-1 --profile default --query "Stacks[0].Outputs[?OutputKey=='AlbDNSName'].OutputValue" --output text)
curl -sS "http://$ALB_DNS/" | sed -n '1,200p'
```

5) Limpieza (importante para evitar cargos):

```bash
STACK_NAME=lab-${USER}-stack SSM_PREFIX=/labs/${USER} ./scripts/delete_stack.sh
```

---

### SSM notes

- `create_ssm_params.py` intenta poblar SSM con los Defaults encontrados en `infra.yml`. Si un parámetro tiene Default vacío, el script no lo llenará (evita parámetros vacíos inválidos). En ese caso edita manualmente el parámetro en la consola SSM o usa `aws ssm put-parameter`.
- `create_stack.sh` hace un `get-parameter` por cada parámetro en el prefijo y cae al valor interno por defecto si no existe.

### Naming and sharing guidance for classes

- Cada alumno debe elegir un `USER` único y usar el patrón `/labs/<USER>` para SSM y `lab-<USER>-stack` como nombre de stack.
- Evitar usar recursos con nombres globales fuera del prefijo (el ALB y TargetGroup usan nombres que incluyen el StackName internamente); el patrón propuesto protege contra colisiones.

### Troubleshooting

- Si CloudFormation falla con errores del tipo "VPC ID ... does not exist": verifica que los IDs en SSM correspondan a la región y cuenta usada. Usa `aws ec2 describe-vpcs --region <REGION>` para listar VPCs.
- Si las instancias no reciben IP pública, comprueba que las subnets indicadas tienen "Auto-assign Public IPv4" habilitado.
# Laboratorio: Despliegue de EC2 + ALB con CloudFormation (Guía didáctica)

¡Bienvenido! 🎓

Este repositorio contiene una plantilla de CloudFormation (`infra.yml`) y scripts para desplegar una aplicación web sencilla (Apache + PHP) en instancias EC2 detrás de un Application Load Balancer (ALB). El objetivo de este laboratorio es aprender a automatizar infraestructuras con CloudFormation y a gestionar configuración mediante AWS Systems Manager (SSM) Parameter Store.

## Contenido del repositorio

- `infra.yml` - Plantilla CloudFormation que define: rol IAM mínimo, instancia EC2, Launch Template, Auto Scaling Group, Application Load Balancer, Target Group y Outputs.
- `create_stack.sh` - Script que crea o actualiza el stack; ahora soporta leer parámetros desde SSM y permite pasar `STACK_NAME` y `SSM_PREFIX` para evitar colisiones.
- `delete_stack.sh` - Script que borra el stack CloudFormation y elimina parámetros SSM bajo un prefijo indicado.
- `scripts/create_ssm_params.py` - Script auxiliar que genera parámetros en SSM a partir del bloque `Parameters` en `infra.yml`.
- `scripts/delete_stack.sh` - Versión alternativa de borrado (útil en entornos compartidos).
- `LAB.md` - Guía paso a paso pensada para profesores y alumnos.

---

## Antes de empezar (Requisitos) ✅

- Tener instalado y configurado el AWS CLI con un perfil válido: `aws configure`.
- Tener Python 3 instalado para ejecutar el script SSM.
- Permisos en la cuenta para gestionar: CloudFormation, SSM Parameter Store, EC2, ELBv2 y IAM.

Consejo: en un entorno de laboratorio compartido, cada alumno debe usar un identificador único para evitar conflictos (ver sección "Buenas prácticas para el laboratorio").

---

## Explicación rápida de la arquitectura 🏗️

- Una o más instancias EC2 ejecutan Apache + PHP (provisionadas vía User Data).
- Un Launch Template permite que el Auto Scaling Group (ASG) lance instancias idénticas.
- Un Application Load Balancer (ALB) en las subnets públicas distribuye tráfico HTTP (puerto 80) hacia el Target Group que apunta a las instancias.
- SSM Parameter Store se usa para guardar valores de configuración (IDs de VPC, subnets, AMI, etc.) sin hardcodearlos en scripts.

---

## Quickstart (paso a paso) 🚀

A continuación un flujo sencillo para desplegar una pila en un entorno compartido.

1) Elige un identificador único para tu práctica (ej.: tu usuario):

```bash
USER=miusuario
STACK_NAME=lab-${USER}-stack
SSM_PREFIX=/labs/${USER}
```

2) (Opcional) Poblar SSM Parameter Store (opcional, facilita la configuración):

```bash
python3 scripts/create_ssm_params.py --template infra.yml --prefix "$SSM_PREFIX" --region us-east-1 --profile default
```

Notas:
- El script crea parámetros con los valores Default del template. Si un parámetro tiene Default vacío, el script no lo creará (evita crear parámetros vacíos que fallan en SSM).
- Puedes editar los parámetros en la consola SSM o con `aws ssm put-parameter` para ajustar valores (por ejemplo `SubnetId` o `SecurityGroupId`).

3) Desplegar la plantilla (leerá SSM si encuentra parámetros bajo `SSM_PREFIX`):

```bash
STACK_NAME="$STACK_NAME" SSM_PREFIX="$SSM_PREFIX" chmod +x create_stack.sh && ./create_stack.sh
```

4) Esperar a que CloudFormation finalice y obtener el DNS del ALB:

```bash
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region us-east-1 --profile default
ALB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region us-east-1 --profile default --query "Stacks[0].Outputs[?OutputKey=='AlbDNSName'].OutputValue" --output text)
curl -sS "http://$ALB_DNS/" | sed -n '1,200p'
```

5) Limpieza (muy importante para evitar cargos):

```bash
STACK_NAME=lab-${USER}-stack SSM_PREFIX=/labs/${USER} ./scripts/delete_stack.sh
```

---

## Explicación detallada de los scripts 🧭

### `create_stack.sh`
- Detecta si el stack existe y decide `create-stack` o `update-stack`.
- Lee parámetros desde SSM si existen (llamadas `aws ssm get-parameter` bajo el prefijo `SSM_PREFIX`). Si el parámetro no existe usa un valor por defecto dentro del script.
- Parámetros configurables por variable de entorno:
  - `STACK_NAME` (ej. `lab-<user>-stack`)
  - `SSM_PREFIX` (ej. `/labs/<user>`)
  - `REGION`, `PROFILE`

### `scripts/create_ssm_params.py`
- Extrae el bloque `Parameters` de `infra.yml` por análisis textual (evita errores con tags como `!Ref`) y crea parámetros en SSM con `aws ssm put-parameter`.
- Útil para inicializar los parámetros en un laboratorio de forma reproducible.

### `scripts/delete_stack.sh` y `delete_stack.sh`
- `delete_stack.sh` (en repo root) elimina el stack y luego borra parámetros SSM bajo el prefijo dado.
- `scripts/delete_stack.sh` es una versión alternativa que puedes usar desde la carpeta `scripts/`.

---

## Buenas prácticas para el laboratorio 👥

- Cada alumno use un `USER` único y el prefijo `/labs/<USER>` para SSM y `lab-<USER>-stack` como nombre de stack.
- Revisa que los IDs de VPC y Subnet usados en SSM existan y pertenezcan a la misma región donde desplegarás.
- Si necesitas valores compartidos (por ejemplo una VPC central), acuerda con el instructor los IDs a usar.
- Para parámetros sensibles, considera `SecureString` y una KMS key por equipo.

---

## Resolución de problemas (Troubleshooting) 🛠️

- Error: "The VPC ID 'vpc-...' does not exist"
  - Causa: estás usando un VPC ID que no existe en la región/ cuenta actualmente configurada.
  - Solución: lista VPCs y Subnets y actualiza tus parámetros SSM:

```bash
aws ec2 describe-vpcs --region us-east-1 --query 'Vpcs[*].[VpcId,IsDefault]' --output table
aws ec2 describe-subnets --region us-east-1 --query 'Subnets[*].[SubnetId,AvailabilityZone,MapPublicIpOnLaunch]' --output table
```

- Error: instancias sin IP pública
  - Revisa si la Subnet tiene habilitado "Auto-assign Public IPv4". Si no, usa otra subnet pública o activa la opción.

- Ver eventos del stack para ver el error raíz:

```bash
aws cloudformation describe-stack-events --stack-name $STACK_NAME --region us-east-1 --profile default --max-items 50
```

---

## Recursos extra y limpieza ♻️

- Para borrar manualmente parámetros SSM:

```bash
aws ssm delete-parameters --names /labs/<USER>/VpcId /labs/<USER>/Subnet1 --region us-east-1 --profile default
```

- Si algo falla y necesitas empezar de cero: elimina el stack y borra el prefijo SSM como se muestra en el Quickstart.

---

Si quieres, puedo:
- Ejecutar los pasos para detectar y completar automáticamente los `SubnetId`/`SecurityGroupId` válidos en SSM para tu cuenta.
- Desplegar un stack de prueba usando un prefijo de laboratorio y mostrarte el HTML servido por el ALB.

¿Qué prefieres que haga a continuación? 😊