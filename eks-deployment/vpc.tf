provider "aws" {
  region = var.region
}
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name = var.eks_cluster_name
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = var.vpc_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names  # get the available azs which can be accessed by an AWS account within the region configured in the provider.
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true                                         # Should be true if you want to provision NAT Gateways for each of your private networks
  single_nat_gateway   = true                                         # Should be true if you want to provision a single shared NAT Gateway across all of your private networks
  enable_dns_hostnames = true                                       # Should be true to enable DNS hostnames in the VPC


# If you don't use the preceding tags, then Cloud Controller Manager determines if a subnet is public or private by examining the route table associated with that subnet. 
# Unlike private subnets, public subnets use an internet gateway to get a direct route to the internet.
# If you don't associate your subnets with either tag, then you receive an error.
tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
