#!/bin/bash

# Setup Parameter - Replace <> with actual values
export VPC_CIDR=<CidrBlock>

# Create VPC
export VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text)

aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=DEV-VPC-$VPC_CIDR