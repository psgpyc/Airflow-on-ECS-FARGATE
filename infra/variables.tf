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


# ALB

variable "alb_name" {
  type = string
  nullable = false

}

variable "is_internal" {

    type = bool
    default = false
    
}

variable "load_balancer_type" {
    type = string
    nullable = false
    default = "application"
}

variable "idle_timeout" {

    type = string
    default = 60
  
}


variable "is_access_log_enabled" {
  description = "Enable ALB access logs to S3."
  type        = bool
  default     = false
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

variable "health_check_path" {
  description = "HTTP path used for target group health checks."
  type        = string
  default     = "/api/v2/monitor/health"

  validation {
    condition     = startswith(var.health_check_path, "/")
    error_message = "health_check_path must start with '/'."
  }
}

# RDS

# variables.tf (root / outer)

variable "db_subnet_group_name" {
  type        = string
  description = "Name for the RDS DB subnet group (passed to the rds module)."
}

variable "db_subnet_group_description" {
  type        = string
  description = "Description for the RDS DB subnet group."
}

variable "pg_instance_class" {
  type        = string
  description = "RDS PostgreSQL instance class (e.g., db.t4g.micro)."
}

variable "pg_engine_version" {
  type        = string
  description = "PostgreSQL engine version for RDS (e.g., 16.3, 15.7)."
}

variable "pg_allocated_storage_gb" {
  type        = number
  description = "Allocated storage in GiB for the RDS instance."
}

variable "pg_db_name" {
  type        = string
  description = "Initial database name to create (e.g., airflow)."
}

variable "pg_master_username" {
  type        = string
  description = "Master username for the PostgreSQL DB instance."
}

variable "pg_master_password" {
  type        = string
  sensitive   = true
  description = "Master password for the PostgreSQL DB instance."
}

# SECRETS

variable "secret_name" {
  type        = string
  description = "Name of the secret in Secrets Manager."
}

variable "airflow_secret_name" {
  description = "Name of the Secrets Manager secret storing Airflow admin credentials."
  type        = string
}

variable "airflow_admin_username" {
  description = "Initial Airflow admin username."
  type        = string

  validation {
    condition     = length(trimspace(var.airflow_admin_username)) > 0
    error_message = "airflow_admin_username must be a non-empty string."
  }
}

variable "airflow_admin_password" {
  description = "Initial Airflow admin password (sensitive)."
  type        = string
  sensitive   = true

  validation {
    condition     = length(trimspace(var.airflow_admin_password)) >= 0
    error_message = "airflow_admin_password must be at least 1 characters."
  }
}


# ECR

variable "ecr_name" {
  type        = string
  nullable    = false
  description = "Base name used to build the ECR repository name (e.g., <name>/airflow)."
}

# IAM
variable "ecs_task_execution_role_description" {

    type = string
    nullable = false
  
}

variable "ecs_task_role_description" {

    type = string
    nullable = false
  
}



# EFS

variable "creation_token" {
  description = "Unique creation token to ensure idempotent EFS file system creation."
  type        = string
  nullable    = false

}


variable "volume_name" {
  description = "Name of the task-level volume (referenced later by container mountPoints.sourceVolume)."
  type        = string
  default     = "airflow-efs"
}