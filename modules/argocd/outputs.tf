output "namespace" {
  description = "ArgoCD namespace."
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "hostname" {
  description = "ArgoCD hostname."
  value       = var.config.hostname
}
