variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "config" {
  description = "Configuration for VPC networking."
  type = object({
    cidr_block           = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    availability_zones   = list(string)
    cluster_name         = string
    open_inbound_acl_rules = list(object({
      rule_number     = number
      rule_action     = string
      protocol        = string
      from_port       = optional(number)
      to_port         = optional(number)
      icmp_code       = optional(number)
      icmp_type       = optional(number)
      cidr_block      = optional(string)
      ipv6_cidr_block = optional(string)
    }))
    open_outbound_acl_rules = list(object({
      rule_number     = number
      rule_action     = string
      protocol        = string
      from_port       = optional(number)
      to_port         = optional(number)
      icmp_code       = optional(number)
      icmp_type       = optional(number)
      cidr_block      = optional(string)
      ipv6_cidr_block = optional(string)
    }))
  })
}
