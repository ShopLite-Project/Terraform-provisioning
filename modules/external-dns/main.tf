locals {
  oidc_provider_host = replace(var.config.oidc_issuer_url, "https://", "")
}

data "aws_route53_zone" "selected" {
  name         = var.config.hosted_zone_name
  private_zone = false
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.config.namespace
    labels = {
      name = var.config.namespace
    }
  }
}

resource "aws_iam_role" "external_dns" {
  name = "${var.tags["Environment"]}-${var.tags["Project"]}-external-dns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.config.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider_host}:sub" = "system:serviceaccount:${var.config.namespace}:${var.config.service_account_name}"
            "${local.oidc_provider_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "external_dns" {
  name = "${var.tags["Environment"]}-${var.tags["Project"]}-external-dns-policy"
  role = aws_iam_role.external_dns.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [data.aws_route53_zone.selected.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = var.config.namespace
  version    = var.config.chart_version

  values = [
    yamlencode({
      provider = {
        name = "aws"
      }
      policy     = var.config.policy
      txtOwnerId = var.config.txt_owner_id
      serviceAccount = {
        create = true
        name   = var.config.service_account_name
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
        }
      }
      sources       = var.config.sources
      domainFilters = var.config.domain_filters
      extraArgs = [
        "--aws-zone-type=${var.config.aws_zone_type}"
      ]
      registry = "txt"
    })
  ]

  depends_on = [
    kubernetes_namespace.external_dns,
    aws_iam_role_policy.external_dns
  ]
}
