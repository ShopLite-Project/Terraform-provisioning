variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "config" {
  type = object({
    instance_name                 = string
    instance_type                 = optional(string, "t3.micro")
    root_volume_size              = optional(number, 20)
    key_name                      = optional(string)
    create_on_public_subnet       = optional(bool, true)
    enable_termination_protection = optional(bool, false)
    allowed_ssh_cidrs             = optional(list(string), ["0.0.0.0/0"])
  })
}

variable "network" {
  type = object({
    vpc_id             = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
  })
}
