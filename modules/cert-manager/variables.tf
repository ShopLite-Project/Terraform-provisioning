variable "region" {
  type = string
}

variable "config" {
  type = object({
    namespace            = string
    chart_version        = string
    cluster_issuer_name  = string
    acme_email           = string
    acme_server          = string
    http01_ingress_class = string
    enable_prometheus    = optional(bool, false)
  })
}
