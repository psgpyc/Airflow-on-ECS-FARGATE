variable "creation_token" {
  description = "Unique creation token to ensure idempotent EFS file system creation."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.creation_token)) > 0
    error_message = "creation_token must be a non-empty string."
  }
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

# ENCRYPTION

variable "kms_key_id" {
  description = "Optional KMS key ARN/ID for EFS encryption at rest. If null, AWS managed key is used."
  type        = string
  default     = null
}

# Mount targets


variable "mount_target_subnet_ids" {
  description = "Subnet IDs where EFS mount targets will be created (typically private subnets, one per AZ)."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.mount_target_subnet_ids) > 0 && alltrue([for s in var.mount_target_subnet_ids : length(trimspace(s)) > 0])
    error_message = "mount_target_subnet_ids must be a non-empty list of subnet IDs."
  }
}

variable "mount_target_sec_group_id" {
  description = "Security group IDs attached to the EFS mount targets (must allow inbound NFS 2049 from ECS task SGs)."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.mount_target_sec_group_id) > 0 && alltrue([for sg in var.mount_target_sec_group_id : length(trimspace(sg)) > 0])
    error_message = "mount_target_sec_group_id must be a non-empty list of security group IDs."
  }
}

# Lifecycle policies

variable "lifecycle_policy" {
  description = "Optional EFS lifecycle policy."
  type = object({
    transition_to_ia      = optional(string, null)
    transition_to_archive = optional(string, null)
  })
  default = null
}

# Access Point (Airflow DAGs)

variable "airflow_uid" {
  description = "POSIX UID used by the access point (should match the Airflow container UID)."
  type        = number
  default     = 50000
}

variable "airflow_gid" {
  description = "POSIX GID used by the access point (should match the Airflow container GID)."
  type        = number
  default     = 50000
}


variable "access_point_config" {
  type = map(string)
  default = {
    "dags": "/dags"
    "logs": "/logs"
    "plugins": "/plugins"
    "config": "/config"
  }

  validation {
    condition = alltrue([ for _,v in var.access_point_config: startswith( v, "/")])
    error_message = "Access Point root path must start with '/'."
  }
  
}


variable "access_permissions" {
  description = "POSIX permissions for the directory (e.g., '0755')."
  type        = string
  default     = "0755"

  validation {
    condition     = can(regex("^0[0-7]{3}$", var.access_permissions))
    error_message = "permissions must be a 4-digit octal string like '0755'."
  }
}