# CloudFormation Intrinsics + EC2 + SSM Connection Guide

## 1. Overview

This template demonstrates key intrinsic functions in CloudFormation:
- `!Ref`
- `!Sub`
- `!GetAtt`
- `!Join`
- `!ImportValue`

It also deploys an **Amazon Linux 2 EC2 instance** with an IAM Role and Instance Profile so you can connect via **AWS SSM Session Manager** (no SSH keys needed).

---

## 2. Requirements

### Your VPC must include:
- A private or public subnet **with route to SSM endpoints**
- Security group allowing **outbound HTTPS (443)**  
- The EC2 IAM role must include:

```
AmazonSSMManagedInstanceCore
CloudWatchAgentServerPolicy
```

### Your EC2 must use:
✅ An AMI compatible with AWS SSM  
➡ Recommended: **Amazon Linux 2**

```
ami-0c02fb55956c7d316
```

---

## 3. Updated Template Snippet (Using Amazon Linux 2)

```
MyEC2Instance:
  Type: AWS::EC2::Instance
  Properties:
    InstanceType: !Ref InstanceType
    ImageId: ami-0c02fb55956c7d316
    IamInstanceProfile: !Ref MyInstanceProfile
    NetworkInterfaces:
      - DeviceIndex: 0
        SubnetId: !Ref SubnetId
        AssociatePublicIpAddress: true
        GroupSet:
          - !Ref InstanceSecurityGroup
    Tags:
      - Key: Name
        Value: !Sub "ec2-${EnvName}"
```

---

## 4. How to Connect via SSM

Once the CloudFormation Stack is deployed, run:

```
aws ssm start-session --target INSTANCE_ID
```

If you used CloudFormation outputs:

```
aws ssm start-session   --target $(aws cloudformation describe-stacks     --stack-name YOUR-STACK-NAME     --query "Stacks[0].Outputs[?OutputKey=='OutInstanceId'].OutputValue"     --output text)
```

If the connection **fails**, verify:
- The EC2 is running
- IAM Role includes AmazonSSMManagedInstanceCore
- The instance can reach SSM endpoints:
  - com.amazonaws.region.ssm
  - com.amazonaws.region.ec2messages
  - com.amazonaws.region.ssmmessages
- Security group allows outbound **443**

---

## 5. Example Outputs

CloudFormation automatically exports:

```
OutInstanceId
OutInstancePrivateIp
OutBucketName
OutSG
```

---

## 6. Example Join and Sub (educational)

```
!Join [ "-", [ "value1", "value2", !Ref EnvName ] ]

!Sub "Instance uses bucket ${MyBucket}"
```

---

## 7. Troubleshooting SSM Connection

| Problem | Cause | Fix |
|--------|--------|------|
| TargetNotConnected | EC2 cannot reach SSM endpoints | Ensure outbound 443 + routing |
| Instance hangs on “pending” | Subnet misconfigured | Add route to IGW or NAT |
| Role attached but still failing | Missing instance profile | Ensure EC2 uses InstanceProfile |

---

## 8. Conclusion

You now have:
- A CloudFormation template using intrinsic functions
- EC2 with IAM + SSM ready
- Command to connect via Session Manager
- Troubleshooting section
