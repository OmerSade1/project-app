variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EKS worker nodes"
  type        = string
}

variable "assume_role" {
  description = "assume_role"
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

