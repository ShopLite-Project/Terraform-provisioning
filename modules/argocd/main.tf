resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.config.namespace
    labels = {
      name = var.config.namespace
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = var.config.namespace
  version    = var.config.chart_version

  values = [
    yamlencode({
      global = {
        domain = var.config.hostname
      }
      configs = {
        params = {
          "server.insecure" = "false"
        }
      }
      server = {
        ingress = {
          enabled          = true
          ingressClassName = var.config.ingress_class_name
          hostname         = var.config.hostname
          tls              = true
          annotations = {
            "cert-manager.io/cluster-issuer"            = var.config.cluster_issuer_name
            "external-dns.alpha.kubernetes.io/hostname" = var.config.hostname
          }
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}
