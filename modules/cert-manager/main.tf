resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.config.namespace
    labels = {
      name = var.config.namespace
    }
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.config.namespace
  version          = var.config.chart_version
  create_namespace = false
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "crds.keep"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = tostring(var.config.enable_prometheus)
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.config.cluster_issuer_name
    }
    spec = {
      acme = {
        email  = var.config.acme_email
        server = var.config.acme_server
        privateKeySecretRef = {
          name = "${var.config.cluster_issuer_name}-account-key"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                ingressClassName = var.config.http01_ingress_class
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager]
}
