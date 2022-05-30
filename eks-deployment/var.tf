variable "region" {
  default     = "eu-west-3"
  description = "AWS region"
}

variable "eks_cluster_name" {
  default     = "EKS-Dev-env"
  description = "EKS cluster name"
}

variable "vpc_name" {
  default     = "EKS-Dev-env"
  description = "VPC name"
}