# Laboratorio: Crear una EC2 con CloudFormation y conectarse via AWS SSM Session Manager

Este laboratorio permite a cada alumno crear su propia instancia EC2 sin usar SSH, sin llaves, y completamente administrada mediante AWS Systems Manager Session Manager.

---

## 1. Arquitectura del laboratorio

Los alumnos crearan:
- 1 instancia EC2
- En una VPC compartida
- En una subnet compartida
- Sin puertos abiertos
- Sin llaves SSH
- Con rol IAM para permitir administracion via SSM

---

## 2. Crear la VPC

El instructor debe crear una VPC para todo el laboratorio.

Valores recomendados:

CIDR: `10.0.0.0/24`

---

## 3. Crear la Subnet

Se recomienda una sola subnet publica:

CIDR: `10.0.0.0/25`

Esta subnet debe tener:
- Route Table con salida a Internet (`0.0.0.0/0`)
- Internet Gateway asociado a la VPC

---

## 4. Plantilla CloudFormation para los alumnos

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: "EC2 instance with SSM connectivity (no SSH)"

Parameters:
  InstanceType:
    Type: String
    Default: t3.micro

  VpcId:
    Type: String

  SubnetId:
    Type: String

  AmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64

  StudentId:
    Type: String
    Description: Unique identifier per student

Resources:

  EC2InstanceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
        - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2InstanceRole

  EC2SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: "No inbound ports required for SSM"
      VpcId: !Ref VpcId
      SecurityGroupIngress: []
      SecurityGroupEgress:
        - IpProtocol: "-1"
          CidrIp: 0.0.0.0/0

  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      IamInstanceProfile: !Ref EC2InstanceProfile
      ImageId: !Ref AmiId
      SubnetId: !Ref SubnetId
      SecurityGroupIds:
        - !Ref EC2SecurityGroup
      Tags:
        - Key: Name
          Value: !Sub "ec2-ssm-${StudentId}"
      UserData:
        Fn::Base64: |
          #!/bin/bash
          yum update -y
          yum install -y amazon-ssm-agent
          systemctl enable amazon-ssm-agent
          systemctl start amazon-ssm-agent

Outputs:
  InstanceId:
    Value: !Ref EC2Instance
    Description: EC2 instance id

  ConnectSSM:
    Value: !Sub "aws ssm start-session --target ${EC2Instance}"
    Description: SSM connect command
```

---

## 5. Parametros para los alumnos

Cada alumno debe recibir:

- VpcId
- SubnetId
- StudentId (identificador unico)

---

## 6. Desplegar el stack

```bash
aws cloudformation deploy   --stack-name ec2-lab-<student>   --template-file ec2-ssm.yml   --parameter-overrides       VpcId=vpc-xxxx       SubnetId=subnet-xxxx       StudentId=<student>   --capabilities CAPABILITY_NAMED_IAM
```

---

## 7. Conectarse via SSM

### Desde consola:
Systems Manager -> Session Manager -> Start session

### Desde CLI:
```bash
aws ssm start-session --target <instance-id>
```

---

## 8. Verificar la instancia

Ejecutar:

```
hostname
uname -a
curl https://aws.amazon.com
```

---

Fin del manual.
