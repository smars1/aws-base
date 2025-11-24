# Manual Completo
## Laboratorio: Crear una EC2 con CloudFormation + Conexión por AWS SSM (sin llaves)

Este laboratorio permite desplegar una instancia EC2 totalmente administrada mediante AWS Systems Manager Session Manager (SSM), sin usar SSH ni llaves, y de forma segura usando IAM Roles y Security Groups sin puertos abiertos.

---

# 1. Arquitectura que se construye

## 1. IAM Role para EC2 (EC2SSMRole)
Permite:
- Registro en SSM
- Conexión sin SSH
- Logs a CloudWatch

Políticas:
- AmazonSSMManagedInstanceCore
- CloudWatchAgentServerPolicy

## 2. Instance Profile
Requerido para adjuntar el rol IAM a la EC2.

## 3. Security Group sin puertos
Sin reglas de entrada:
- No SSH
- No HTTP
- No RDP

Solo comunicación saliente al puerto 443 para SSM.

## 4. Instancia EC2 (MyEC2Instance)
Incluye:
- Ubuntu 20.04
- t3.micro
- Subnet seleccionada
- Rol IAM
- Security Group seguro
- IP pública

## 5. Outputs
- ID de la instancia
- IP pública
- Comando SSM

---

# 2. Prerrequisitos

Instructor:
- Crear VPC
- Crear Subnet pública

Alumno:
- Tener AWS CLI
- Datos: VPC_ID, SUBNET_ID, USERNAME

---

# 3. Estructura sugerida
```
bootcamp_institue/
│── deploy/
│     ├── deploy_ec2_ssm.sh
│     └── cloud_formation/template_ec2.yaml
│── .env
```
---

# 4. Archivo .env
```
VPC_ID=vpc-xxxx
SUBNET_ID=subnet-xxxx
USERNAME=DiegoAtzin
ENVNAME=dev
TEMPLATE_FILE=./deploy/cloud_formation/template_ec2.yaml
AMI_ID=ami-0ecb62995f68bb549
```
---

# 5. Ejecución del despliegue
```
./deploy/deploy_ec2_ssm.sh
```
---

# 6. Conexión via SSM
```
aws ssm start-session --target i-xxxxxxxxxxxxxx
```
---

# 7. Errores comunes
```
ROLBACK_COMPLETE → borrar stack  
PublicIp no existe → subnet sin IP pública habilitada
```
---

# 8. Conclusiones

- EC2 administrada via SSM  
- Sin SSH, 100% segura  
- Despliegue automatizado  
- CloudFormation + Bash + .env  
