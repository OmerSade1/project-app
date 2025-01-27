data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az = data.aws_availability_zones.available.names

  public_subnet_cidrs_map = zipmap(
    local.az,
    [for index, az in local.az : cidrsubnet(var.cidr_block, 8, index)]
  )

  private_subnet_cidrs_map = zipmap(
    local.az,
    [for index, az in local.az : cidrsubnet(var.cidr_block, 8, index + length(local.az))]
  )

  public_subnet_cidrs = values(local.public_subnet_cidrs_map)
  private_subnet_cidrs = values(local.private_subnet_cidrs_map)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = var.cidr_block

  azs             = local.az
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Terraform = "true"
    Environment = var.environment
    "kubernetes.io/role/elb"           = "1"
    "kubernetes.io/cluster/my-cluster-eks" = "owned"
  }

  private_subnet_tags = {
    Terraform = "true"
    Environment = var.environment
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/my-cluster-eks" = "owned"
  }
}


data "aws_route53_zone" "example" {
  name = var.domain_name 
}

output "zone_id" {
  value = data.aws_route53_zone.example.id
}

output "domain_name" {
  value = data.aws_route53_zone.example.name
}