locals {
  env = merge(
    yamldecode(file("${path.module}/../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../environments/shoplite_sandbox.yaml"))
  )
}

terraform {
  required_version = ">= 1.6.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = local.env.sandbox.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.env.sandbox.s3_backend.bucket_name
    key    = "${local.env.sandbox.s3_backend.key_prefix}/vpc-core-network/terraform.tfstate"
    region = local.env.sandbox.aws_region
  }
}

module "eks_cluster" {
  source  = "../../../modules/eks-cluster"
  region  = local.env.sandbox.aws_region
  tags    = local.env.sandbox.tags
  config  = local.env.sandbox.eks_cluster
  network = data.terraform_remote_state.vpc.outputs
}
