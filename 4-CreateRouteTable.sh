#!/bin/bash

# Setup Parameter - Replace <> with actual values
export VPC_ID=<VpcId>
export NATGW_ID=<NatGatewayId>
export SUBNET_ID_INTERNET=<SubnetId>

# Create custom routable
export RTB_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text )

aws ec2 create-tags --resources $RTB_ID --tags Key=Name,Value=DEV-RouteTable-Internet

# Add route entry that direct traffic to internet through NAT Gateway

aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NATGW_ID --output text 

# Associate the custom routable to the subnet that required internet connection

aws ec2 associate-route-table --route-table-id $RTB_ID --subnet-id $SUBNET_ID_INTERNET --output text 
