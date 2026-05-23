output "namespace" {
  description = "cert-manager namespace."
  value       = kubernetes_namespace.cert_manager.metadata[0].name
}

output "cluster_issuer_name" {
  description = "ClusterIssuer created for cert-manager."
  value       = kubernetes_manifest.cluster_issuer.manifest.metadata.name
}
