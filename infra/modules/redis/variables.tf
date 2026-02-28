variable "redis_cluster_name" {
  description = "Name prefix for Redis resources (used in subnet group name + cluster_id)."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.redis_cluster_name)) > 0
    error_message = "redis_cluster_name must be a non-empty string."
  }
}

variable "redis_private_subnet_ids" {
  description = "List of private subnet IDs for the ElastiCache subnet group (recommended: at least 2 across AZs)."
  type        = list(string)
  nullable    = false

  validation {
    condition = (
      length(var.redis_private_subnet_ids) >= 1 
    )
    error_message = "redis_private_subnet_ids must contain at least 1 valid subnet-xxxxxxxx id."
  }
}

variable "redis_security_group_id" {
  description = "Security group ID attached to the Redis cluster (must allow 6379 from Airflow scheduler/workers)."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.redis_security_group_id))
    error_message = "redis_security_group_id must be a valid sg-xxxxxxxx id."
  }
}

variable "redis_node_type" {
  description = "ElastiCache node type (e.g., cache.t3.micro)."
  type        = string
  default     = "cache.t3.micro"

  validation {
    condition     = length(trimspace(var.redis_node_type)) > 0
    error_message = "redis_node_type must be a non-empty string."
  }
}

variable "redis_num_cache_nodes" {
  description = "Number of cache nodes for aws_elasticache_cluster (use 1 for cheapest single-node)."
  type        = number
  default     = 1

  validation {
    condition     = var.redis_num_cache_nodes >= 1
    error_message = "redis_num_cache_nodes must be >= 1."
  }
}

variable "redis_port" {
  description = "Redis port."
  type        = number
  default     = 6379

  validation {
    condition     = var.redis_port > 0 && var.redis_port <= 65535
    error_message = "redis_port must be between 1 and 65535."
  }
}

variable "apply_immediately" {
  description = "Whether changes should be applied immediately (true is fine for portfolio; false is safer for prod change control)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to Redis resources."
  type        = map(string)
  default = {
    component  = "cache"
    service    = "redis"
    managed_by = "terraform"
  }
}