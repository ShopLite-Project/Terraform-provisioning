variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "config" {
  type = object({
    bucket_name         = string
    dynamodb_table_name = string
    key_prefix          = string
    force_destroy       = optional(bool, false)
  })
}
