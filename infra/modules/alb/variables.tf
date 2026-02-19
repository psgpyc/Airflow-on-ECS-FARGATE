variable "name" {

    type = string
    nullable = false

    validation {
      condition = length(trimspace(var.name)) > 0
      error_message = "Name of the load balancer is required."
    }
}

variable "is_internal" {

    type = bool
    default = false
    
}

variable "load_balancer_type" {
    type = string
    nullable = false
    default = "application"

    validation {
      condition = var.load_balancer_type == "application"
      error_message = "This module only supports application load balancer"
    }  
}

variable "security_groups" {
    type = list(string)
    nullable = false

    validation {
      condition = length(var.security_groups) > 0 
      error_message = "ALB must have a security group id assigned"
    }

}


variable "subnets" {
    type = list(string)
    nullable = false

    validation {
      condition = length(var.subnets) >= 2
      error_message = "ALB must be deployed in at least two subnets (multi-AZ)."
    }
  
}

variable "ip_address_type" {

    type = string
    default = "ipv4"

    validation {
      condition = (
        contains(["ipv4", "dualstack"], lower(trimspace(var.ip_address_type)))
      )
      error_message = "ip_address_type must be one of: ipv4, dualstack"
    }
  
}

variable "idle_timeout" {

    type = string
    default = 60
  
}

variable "enable_deletion_protection" {
    type = bool
    default = false

}

variable "tags" {
  description = "Common tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}

variable "is_access_log_enabled" {
  description = "Enable ALB access logs to S3."
  type        = bool
  default     = false
}

variable "bucket_id" {
  description = "S3 bucket name for ALB access logs (required when is_access_log_enabled = true)."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.is_access_log_enabled == false
      ||
      (var.bucket_id != null)
    )
    error_message = "bucket_id must be set to a non-empty S3 bucket name when is_access_log_enabled = true."
  }
}

variable "bucket_prefix" {
  description = "S3 prefix for ALB access logs (optional)."
  type        = string
  default     = ""
}

# TARGET GROUP

variable "target_g_port" {
  description = "Port the load balancer uses when routing traffic to targets."
  type        = number
  default = 8080

  validation {
    condition     = var.target_g_port >= 1 && var.target_g_port <= 65535
    error_message = "target_g_port must be a valid TCP/UDP port (1-65535)."
  }
}

variable "target_g_protocol" {
  description = "Protocol for routing traffic to targets. Common values: HTTP, HTTPS."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], upper(trimspace(var.target_g_protocol)))
    error_message = "target_g_protocol must be one of: HTTP, HTTPS."
  }
}

variable "target_type" {
  description = "Target type for the target group. For ECS Fargate use 'ip'."
  type        = string
  default     = "ip"

  validation {
    condition     = contains(["ip", "instance", "lambda"], lower(trimspace(var.target_type)))
    error_message = "target_type must be one of: ip, instance, lambda."
  }
}

variable "target_g_vpc_id" {
  description = "VPC ID where the target group is created."
  type        = string

  validation {
    condition     = length(trimspace(var.target_g_vpc_id)) > 0
    error_message = "target_g_vpc_id must be a non-empty string."
  }
}

variable "health_check_path" {
  description = "HTTP path used for target group health checks."
  type        = string
  default     = "/api/v2/monitor/health"

  validation {
    condition     = startswith(var.health_check_path, "/")
    error_message = "health_check_path must start with '/'."
  }
}