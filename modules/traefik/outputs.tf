output "namespace" {
  description = "Traefik namespace."
  value       = kubernetes_namespace.traefik.metadata[0].name
}

output "service_name" {
  description = "Traefik service name."
  value       = "traefik"
}
