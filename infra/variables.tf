variable "aws_profile" {

    type = string
    description = "The profile identifier to use to connect to AWS"
    nullable = false
    default = "default"

}


variable "aws_region" {

    type = string
    description = "The default AWS region"
    nullable = false
    default = "eu-west-2"
  
}

# VPC

variable "name" {

  description = "Name prefix for the VPC."
  type        = string

}

variable "cidr_block" {
  description = "VPC CIDR block (e.g. 10.0.0.0/16)."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid CIDR (e.g. 10.0.0.0/16)."
  }
}

variable "subnet_config" {

    type = map(object({
      cidr_block = string
      availability_zone= string
      type= string  # public or private
      tags = optional(map(string), {})
    }))

}


# SECURITY GROUP

variable "sec_group_config" {

  type = map(object({

    sec_group_name = string
    sec_group_description = string

  }))
  
}