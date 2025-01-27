module "eks" {
  depends_on = [ module.vpc ]
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "my-cluster-eks"
  cluster_version = "1.31"

  enable_irsa = false
 
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id

  control_plane_subnet_ids = [
    for az, subnet_id in zipmap(local.az, module.vpc.public_subnets) : subnet_id
    if az != "us-east-1e"
  ]

  subnet_ids = [
    for az, subnet_id in zipmap(local.az, module.vpc.private_subnets) : subnet_id
    if az != "us-east-1e"
  ]

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }


   eks_managed_node_groups = {
    worker_nodes = {
      min_size       = 1
      max_size       = 4
      desired_size   = 2
      instance_types = [var.instance_type]
      
     iam_role_additional_policies = {
     "SecretsManagerReadWrite" = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
      }
            
    }
  }

  cluster_security_group_additional_rules = {
    allow_all_traffic_between_nodes = {
      description                = "Allow all traffic between nodes"
      from_port                  = 0
      to_port                    = 0
      protocol                   = "-1" 
      type                       = "ingress"
      source_node_security_group = true
  }

  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

data "aws_eks_cluster" "my_cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


resource "aws_security_group_rule" "allow_all_between_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" 
  security_group_id = module.eks.node_security_group_id
  source_security_group_id = module.eks.node_security_group_id
}
