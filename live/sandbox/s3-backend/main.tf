locals {
  env = merge(
    yamldecode(file("${path.module}/../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../environments/shoplite_sandbox.yaml"))
  )
}

terraform {
  required_version = ">= 1.6.0"

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

module "s3_backend" {
  source = "../../../modules/s3-backend"
  region = local.env.sandbox.aws_region
  tags   = local.env.sandbox.tags
  config = local.env.sandbox.s3_backend
}
