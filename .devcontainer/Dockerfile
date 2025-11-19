FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install base dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    python3 \
    python3-pip \
    groff \
    less \
    gnupg \
    software-properties-common

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install Terraform (correct modern method)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

SHELL ["/bin/bash", "-c"]
