variable "region" {
  default     = "eu-west-3"
  description = "AWS region"
}

variable "eks_cluster_name" {
  default     = "halborn-dev-env"
  description = "EKS cluster name"
}

variable "vpc_name" {
  default     = "halborn-stg-env"
  description = "VPC name"
}