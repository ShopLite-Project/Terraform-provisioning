variable "region" {
  type = string
}

variable "config" {
  type = object({
    namespace           = string
    chart_version       = string
    hostname            = string
    ingress_class_name  = string
    cluster_issuer_name = string
  })
}
