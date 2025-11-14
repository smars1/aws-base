# ☁️ INTRODUCCIÓN GENERAL AL PROYECTO AWS-AAD

Este laboratorio está diseñado para que los alumnos aprendan a **desplegar infraestructura en AWS usando código**.  
Durante el proyecto, construiremos recursos reales en la nube mediante **CloudFormation**, **AWS CLI** y **Python (boto3)**.  
El objetivo es comprender **qué hace cada componente** y **por qué se usa** dentro de un flujo profesional de DevOps o Cloud Engineering.

---

## 🧩 1️⃣ Componentes principales del laboratorio

### 🧱 Git y GitHub — Control de versiones
**Qué es:**  
Sistema de control de versiones que registra los cambios del código.  
**Para qué sirve:**  
- Clonar el proyecto base (`git clone`)  
- Crear una rama personal (`git checkout -b`)  
- Guardar avances (`git add`, `git commit`, `git push`)  

💡 *Tu rama es tu “espacio personal” dentro del proyecto.*

---

### 🐍 Python + Boto3 — Automatización en AWS
**Qué es:**  
Boto3 es la librería oficial de AWS para Python. Permite interactuar con los servicios AWS por código.  
**Para qué sirve:**  
- Crear recursos, parámetros o configuraciones desde scripts Python.  
- Automatizar procesos repetitivos (sin usar consola web).  

💡 *Con Python + Boto3 le damos instrucciones a AWS mediante código.*

---

### 🧰 AWS CLI (Command Line Interface)
**Qué es:**  
Herramienta oficial de AWS que permite ejecutar comandos desde la terminal.  
**Para qué sirve:**  
- Configurar credenciales (`aws configure`).  
- Ejecutar despliegues y consultas (CloudFormation, EC2, SSM).  

💡 *Es la forma de “hablar con AWS” desde tu computadora.*

---

### 📜 AWS CloudFormation — Infraestructura como Código (IaC)
**Qué es:**  
Servicio que crea infraestructura automáticamente usando plantillas YAML o JSON.  
**Para qué sirve:**  
- Desplegar toda la infraestructura declarada en `infra.yml`.  
- Crear y eliminar recursos de forma controlada.  

💡 *Tu archivo YAML es como el plano de una casa: AWS la construye por ti.*

---

### 🧩 AWS Systems Manager (SSM)
**Qué es:**  
Servicio para administrar configuraciones y parámetros en AWS.  
**Para qué sirve:**  
- Guardar valores seguros (contraseñas, IDs, configuraciones).  
- Automatizar parámetros con `create_ssm_params.py`.  

💡 *Es tu almacén seguro de variables y configuraciones.*

---

### ⚙️ Archivos `.sh` — Automatización con Bash
**Qué son:**  
Scripts que ejecutan comandos automáticamente (por ejemplo, crear o eliminar una pila).  
**Para qué sirven:**  
- `create_stack.sh`: despliega la infraestructura.  
- `delete_stack.sh`: elimina la infraestructura creada.  

💡 *Son tus “botones automáticos” para manejar AWS.*

---

## 🧱 2️⃣ Infraestructura que construiremos en AWS

Durante el laboratorio, los alumnos crearán una **infraestructura mínima pero funcional** compuesta por red, instancias y escalado automático.  
Estos son los componentes clave que aparecerán en el archivo `infra.yml` o como parámetros:

---

### 🌐 **VPC_ID (Virtual Private Cloud)**
**Qué es:**  
La VPC es una red privada dentro de AWS donde se ejecutan todos tus recursos (instancias, bases de datos, etc.).  
**Para qué sirve:**  
- Aislar tu entorno de red.  
- Controlar direcciones IP, subredes y seguridad.  

💡 *Piensa en la VPC como tu “red local” dentro de AWS.*

---

### 🧩 **SUBNET_ID / SUBNET1 / SUBNET2**
**Qué son:**  
Subredes dentro de la VPC que dividen la red en zonas de disponibilidad distintas.  
**Para qué sirven:**  
- Distribuir recursos entre distintas zonas (alta disponibilidad).  
- Conectar tus instancias a Internet (subnet pública) o mantenerlas privadas (subnet privada).  

💡 *Las subnets son “habitaciones” dentro de tu red (VPC).*

---

### 💻 **INSTANCE_TYPE**
**Qué es:**  
Define la capacidad de cómputo (CPU, RAM) de tu instancia EC2.  
Ejemplo: `t2.micro`, `t3.small`, `m5.large`.  
**Para qué sirve:**  
- Determina cuánta potencia tendrá tu servidor virtual.  

💡 *Es como elegir el tamaño de tu computadora en la nube.*

---

### 🧠 **INSTANCE_NAME**
**Qué es:**  
Etiqueta que identifica a tu instancia dentro de AWS.  
**Para qué sirve:**  
- Facilita reconocer tus recursos (nombre visible en el panel EC2).  

💡 *Es el nombre “amigable” de tu servidor.*

---

### 🔒 **SECURITY_GROUP_ID**
**Qué es:**  
Conjunto de reglas de firewall asociadas a tu instancia.  
**Para qué sirve:**  
- Controla qué tráfico puede entrar o salir (por ejemplo, permitir SSH o HTTP).  

💡 *Es el “guardia de seguridad” de tu instancia.*

---

### 🧱 **LAUNCH_TEMPLATE_NAME**
**Qué es:**  
Plantilla que define cómo lanzar una instancia (tipo, red, imagen, tags, etc.).  
**Para qué sirve:**  
- Permite lanzar instancias nuevas con la misma configuración sin reescribir parámetros.  

💡 *Es el “formato prellenado” para crear instancias.*

---

### ⚖️ **AUTOSCALING_GROUP_NAME**
**Qué es:**  
Grupo que gestiona varias instancias EC2 de forma dinámica.  
**Para qué sirve:**  
- Crea o elimina instancias según la demanda.  
- Mantiene siempre una cantidad mínima de servidores activos.  

💡 *Es tu sistema de “crecimiento automático” en la nube.*

---

### 🏷️ **TAG_NAME**
**Qué es:**  
Etiqueta de metadatos aplicada a los recursos.  
**Para qué sirve:**  
- Identificar tus recursos por nombre, propósito o propietario.  
- Facilitar búsqueda y organización en AWS.  

💡 *Los tags son como etiquetas adhesivas para clasificar tus recursos.*

---

### 💿 **LATEST_AMI_ID**
**Qué es:**  
AMI significa *Amazon Machine Image*: es la plantilla base para crear una instancia EC2 (sistema operativo + software).  
**Para qué sirve:**  
- Define qué sistema operativo tendrá la instancia (por ejemplo, Amazon Linux 2).  
- El script busca la **última AMI disponible** para mantener el entorno actualizado.  

💡 *La AMI es la “imagen del disco duro” con la que AWS crea tu servidor.*

---

## 🔗 3️⃣ Diagrama conceptual del flujo

```mermaid
flowchart TD
  A[GitHub Repo] --> B[Clonación y Rama Personal]
  B --> C[Configuración AWS CLI]
  C --> D[Infraestructura CloudFormation (infra.yml)]
  D --> E[Recursos en AWS]
  E --> F[EC2 / Subnets / Security Group / Autoscaling]
  E --> G[SSM Parameters]
  F --> H[Evaluación del alumno]
```

💡 *Este diagrama representa cómo tu código se convierte en infraestructura real en la nube.*

---

## 🚀 Conclusión

Al finalizar el laboratorio, habrás aprendido:
- Cómo automatizar infraestructura con CloudFormation.  
- Cómo configurar AWS CLI y Boto3 para conectarte a tu cuenta.  
- Cómo ejecutar, revisar y eliminar recursos reales en AWS.  
- Cómo documentar tu progreso en GitHub mediante ramas personales.

> Este proyecto te introduce a los conceptos fundamentales de **Infraestructura como Código (IaC)** y **automatización en la nube**, la base del trabajo de un **Cloud Engineer o DevOps profesional**.

---

📘 **Autor:** Diego Pineda  
📅 **Versión:** 1.0  
💬 *Introducción al laboratorio AWS-AAD — Componentes y recursos de infraestructura en AWS.*
