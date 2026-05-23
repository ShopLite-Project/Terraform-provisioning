output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Cluster security group ID."
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Node security group ID."
  value       = aws_security_group.node_group.id
}

output "kubeconfig_command" {
  description = "Recommended AWS CLI command to update kubeconfig."
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA-enabled add-ons."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster."
  value       = aws_iam_openid_connect_provider.this.url
}
