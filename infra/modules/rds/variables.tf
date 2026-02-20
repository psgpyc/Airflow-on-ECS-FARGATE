variable "name" {
  type        = string
  nullable    = false
  description = "Name used for the DB subnet group and as a base for resource naming."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name cannot be empty."
  }
}

variable "description" {
  type        = string
  nullable    = false
  description = "Description for the DB subnet group."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "description cannot be empty."
  }
}

variable "subnet_ids" {
  type        = list(string)
  nullable    = false
  description = "List of subnet IDs for the DB subnet group. Must include subnets in at least two AZs (AWS requirement)."

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "subnet_ids must contain at least 2 subnets (in at least two AZs)."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "pg_engine_version" {
  type        = string
  nullable    = false
  description = "PostgreSQL engine version for the RDS instance (e.g., 16.3, 15.7)."

  validation {
    condition     = length(trimspace(var.pg_engine_version)) > 0
    error_message = "pg_engine_version cannot be empty."
  }
}

variable "pg_instance_class" {
  type        = string
  nullable    = false
  description = "RDS instance class (e.g., db.t4g.micro)."

  validation {
    condition     = length(trimspace(var.pg_instance_class)) > 0
    error_message = "pg_instance_class cannot be empty."
  }
}

variable "pg_allocated_storage_gb" {
  type        = number
  nullable    = false
  description = "Allocated storage in GiB for the RDS instance."

  validation {
    condition     = var.pg_allocated_storage_gb >= 20
    error_message = "pg_allocated_storage_gb must be at least 20 GiB."
  }
}

variable "pg_db_name" {
  type        = string
  nullable    = false
  description = "Initial database name to create inside PostgreSQL."

  validation {
    condition     = length(trimspace(var.pg_db_name)) > 0
    error_message = "pg_db_name cannot be empty."
  }
}

variable "pg_master_username" {
  type        = string
  nullable    = false
  description = "Master username for the PostgreSQL DB instance."

  validation {
    condition     = length(trimspace(var.pg_master_username)) > 0
    error_message = "pg_master_username cannot be empty."
  }
}

variable "pg_master_password" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Master password for the PostgreSQL DB instance."

  validation {
    condition     = length(var.pg_master_password) >= 12
    error_message = "pg_master_password must be at least 12 characters."
  }
}

variable "list_of_rds_security_group_ids" {
  type        = list(string)
  nullable    = false
  description = "List of security group IDs to attach to the RDS instance."

  validation {
    condition     = length(var.list_of_rds_security_group_ids) >= 1
    error_message = "list_of_rds_security_group_ids must contain at least 1 security group id."
  }
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the DB instance should be publicly accessible."
  default     = false
}

variable "multi_az" {
  type        = bool
  description = "Whether to enable Multi-AZ. For portfolio cost control, default is false."
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final snapshot on deletion (useful for iteration)."
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection."
  default     = true
}