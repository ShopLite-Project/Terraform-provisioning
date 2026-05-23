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
  }
}

provider "aws" {
  region = local.env.sandbox.aws_region
}

module "vpc_core_network" {
  source = "../../../modules/vpc-core-network"
  region = local.env.sandbox.aws_region
  tags   = local.env.sandbox.tags
  config = local.env.sandbox.vpc_core_network
}
