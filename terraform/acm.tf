module "acm" {
  depends_on = [ module.eks_blueprints_addons ]
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name  = var.domain_name
  zone_id      = data.aws_route53_zone.example.id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
    "app.${var.domain_name}",
  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}