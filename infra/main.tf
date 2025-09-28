provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "starbucks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a","ap-south-1b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24","10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "starbucks-eks"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["m7i-flex.large"]
    }
  }

  cluster_endpoint_public_access        = true
  cluster_endpoint_private_access       = false
  cluster_endpoint_public_access_cidrs  = ["0.0.0.0/0"]

  # 👇 Add this to give your IAM user cluster-admin
  access_entries = {
    sachinpatkari = {
      principal_arn = "arn:aws:iam::422228629182:user/sachinpatkari"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}
