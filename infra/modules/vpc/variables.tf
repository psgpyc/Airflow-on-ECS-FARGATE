variable "name" {
  description = "Name prefix for the VPC."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be a non-empty string."
  }
}

variable "cidr_block" {
  description = "VPC CIDR block (e.g. 10.0.0.0/16)."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid CIDR (e.g. 10.0.0.0/16)."
  }
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "enable_network_address_usage_metrics" {
  description = "Enable VPC network address usage metrics."
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "VPC instance tenancy: default or dedicated."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be 'default' or 'dedicated'."
  }
}


# subnet

variable "subnet_config" {

    type = map(object({
      cidr_block = string
      availability_zone= string
      type= string  # public or private
      tags = optional(map(string), {})
    }))

    validation {
      condition = alltrue([
        for _, s in var.subnet_config:

            can(cidrnetmask(s.cidr_block)) && contains(["public", "private"], s.type)

      ])
      error_message = "Each subnet must have a valid cidr_block and tier must be 'public' or 'private'"
    }
  
}