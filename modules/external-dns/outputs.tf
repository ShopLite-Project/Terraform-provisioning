output "namespace" {
  description = "External DNS namespace."
  value       = kubernetes_namespace.external_dns.metadata[0].name
}

output "service_account_role_arn" {
  description = "IRSA role ARN used by External DNS."
  value       = aws_iam_role.external_dns.arn
}
