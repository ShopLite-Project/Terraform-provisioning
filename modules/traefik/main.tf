resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.config.namespace
    labels = {
      name = var.config.namespace
    }
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = var.config.namespace
  version    = var.config.chart_version

  values = [
    yamlencode({
      deployment = {
        replicas = var.config.replicas
      }
      service = {
        type = var.config.service_type
      }
      ingressClass = {
        enabled        = true
        isDefaultClass = var.config.is_default_ingress_class
        name           = var.config.ingress_class_name
      }
      ports = {
        web = {
          redirectTo = "websecure"
        }
        websecure = {
          tls = {
            enabled = true
          }
        }
      }
      ingressRoute = {
        dashboard = {
          enabled = var.config.dashboard_enabled
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.traefik]
}
