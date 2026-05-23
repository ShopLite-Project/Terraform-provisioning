variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "config" {
  type = object({
    namespace            = string
    chart_version        = string
    policy               = string
    txt_owner_id         = string
    service_account_name = string
    hosted_zone_name     = string
    domain_filters       = list(string)
    sources              = list(string)
    aws_zone_type        = string
    oidc_provider_arn    = string
    oidc_issuer_url      = string
  })
}
