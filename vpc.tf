provider "aws" {
  region = "us-east-2"
}

variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availability_zones" "azs" {}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.5"
  # insert the 23 required variables here
  name=var.vpc_name
  cidr=var.vpc_cidr_block
  private_subnets=var.private_subnet_cidr_blocks
  public_subnets=var.public_subnet_cidr_blocks
  azs= data.aws_availability_zones.azs.names

 enable_nat_gateway=true
 single_nat_gateway=true
 enable_dns_hostnames=true

 tags ={
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
 }
 public_subnet_tags ={
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
 }
 private_subnet_tags ={
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
 }
}