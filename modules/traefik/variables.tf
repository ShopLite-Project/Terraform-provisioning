variable "region" {
  type = string
}

variable "config" {
  type = object({
    namespace                = string
    chart_version            = string
    ingress_class_name       = string
    replicas                 = optional(number, 1)
    service_type             = optional(string, "LoadBalancer")
    is_default_ingress_class = optional(bool, true)
    dashboard_enabled        = optional(bool, false)
  })
}
