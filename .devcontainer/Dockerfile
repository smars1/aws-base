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
