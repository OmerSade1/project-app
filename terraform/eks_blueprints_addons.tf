module "eks_blueprints_addons" {
  depends_on = [ helm_release.argocd ]
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn


  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
  aws_load_balancer_controller = {
    set = [
      {
        name  = "vpcId"
        value = module.vpc.vpc_id
      },
      {
        name  = "region"
        value = var.region
      },
    ]

  enable_external_dns                    = true
  cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/${data.aws_route53_zone.example.id}"]


  tags = {
    Environment = var.environment
  }
 }
}