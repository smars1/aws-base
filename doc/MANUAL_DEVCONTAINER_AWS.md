# Manual Completo – DevContainer AWS + Python (Para Alumnos)

## 1. Introducción
Este manual explica cómo trabajar con un entorno profesional utilizando DevContainers en GitHub Codespaces o VS Code.

## 2. Estructura del Proyecto
```
repo/
 ├── .devcontainer/
 │   ├── devcontainer.json
 │   └── Dockerfile
 │   └── requirements.txt
 │   └── bash.sh
 ├── src/
 └── scripts/
```

## 3. Dockerfile
```Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# paquete necesarios de ubuntu 
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    python3.12-venv \
    groff \
    less \
    gnupg \
    software-properties-common

# instala dependecias de python [evitar haacer esto en el dockerfile]
#RUN pip3 install --no-cache-dir     boto3==1.34.94     pandas==2.2.4   requests==2.32.3

# Create virtual environment
RUN python3 -m venv /opt/venv

# activa el entorno para futuros comandos
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements
COPY requirements.txt /tmp/requirements.txt

# instala dependecias de python desde el archivo requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt


# Instala AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip



# Instala Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

SHELL ["/bin/bash", "-c"]

```

## 4. devcontainer.json
```json
{
    "name": "aws-base",
    "build": {
        "dockerfile": "Dockerfile",
        "context": "."
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-azuretools.vscode-docker"
            ]
        }
    }
}
```

## 5. requirements.txt
```
boto3==1.34.94
pandas==2.2.2
requests==2.32.3
```

## 6. Instalación de Dependencias
```bash
pip install -r requirements.txt
```

## 7. Desinstalación
```bash
pip uninstall boto3
pip uninstall -r requirements.txt -y
```

## 8. Troubleshooting
### Rebuild container
```
Dev Containers: Rebuild Container
```

### Verificar venv
```bash
which python
which pip
```

