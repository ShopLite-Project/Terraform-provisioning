variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "config" {
  type = object({
    cluster_name              = string
    kubernetes_version        = string
    endpoint_private_access   = optional(bool, true)
    endpoint_public_access    = optional(bool, true)
    instance_types            = optional(list(string), ["t3.medium"])
    desired_size              = optional(number, 2)
    min_size                  = optional(number, 2)
    max_size                  = optional(number, 3)
    disk_size                 = optional(number, 20)
    capacity_type             = optional(string, "ON_DEMAND")
    ami_type                  = optional(string, "AL2023_x86_64_STANDARD")
    enabled_cluster_log_types = optional(list(string), ["api", "audit", "authenticator"])
  })
}

variable "network" {
  type = object({
    vpc_id             = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
  })
}
