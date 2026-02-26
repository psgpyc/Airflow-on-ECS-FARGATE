variable "family" {
  description = "Task definition family name."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.family)) > 0
    error_message = "family must be a non-empty string."
  }
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN (ECR pull, CloudWatch logs, secrets injection as needed)."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.execution_role_arn)) > 0
    error_message = "execution_role_arn must be a non-empty string."
  }
}

variable "task_role_arn" {
  description = "ECS task role ARN (permissions used by application code at runtime)."
  type        = string
  nullable    = true

  validation {
    condition     = var.task_role_arn != null && length(trimspace(var.task_role_arn)) > 0
    error_message = "task_role_arn must be a non-empty string."
  }
}

variable "cpu" {
  description = "Task CPU units for Fargate (e.g., 256, 512, 1024, 2048, 4096)."
  type        = number
  default = 1024

  validation {
    condition     = var.cpu > 0
    error_message = "cpu must be a positive number."
  }
}

variable "memory" {
  description = "Task memory (MiB) for Fargate (e.g., 512, 1024, 2048, 4096, etc.)."
  type        = number
  default = 2048

  validation {
    condition     = var.memory > 0
    error_message = "memory must be a positive number."
  }
}

variable "cpu_architecture" {
  description = "CPU architecture for the task runtime platform."
  type        = string
  default     = "ARM64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "cpu_architecture must be one of: X86_64, ARM64."
  }
}

variable "ephemeral_storage_gib" {
  description = "Optional ephemeral storage size in GiB (Fargate default is 20). Set null to omit."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags applied to the ECS task definition."
  type        = map(string)
  default     = {}
}

# volumes

variable "has_volume" {
  description = "Whether to create a EFS volume block on the task definition."
  type        = bool
  default     = false
}

variable "volume_name" {
  description = "Name of the task-level volume (referenced later by container mountPoints.sourceVolume)."
  type        = string
  default     = "airflow-efs"

  validation {
    condition     = length(trimspace(var.volume_name)) > 0
    error_message = "volume_name must be a non-empty string."
  }
}

variable "efs_file_system_id" {
  description = "EFS file system ID to attach (fs-xxxxxxxx). Required if has_volume = true."
  type        = string
  default     = ""

  validation {
    condition = (
      var.has_volume == false
      ||
      (length(trimspace(var.efs_file_system_id)) > 0)
    )
    error_message = "efs_file_system_id must be set when has_volume = true."
  }
}

variable "efs_access_point_id" {
  description = "EFS access point ID to use for mounting. Required if has_volume = true."
  type        = string
  default     = ""

  validation {
    condition = (
      var.has_volume == false
      ||
      (length(trimspace(var.efs_access_point_id)) > 0)
    )
    error_message = "efs_access_point_id must be set when has_volume = true."
  }
}

# Container definitions

variable "container_definitions" {
    description = "A list of valid container definitions provided as a single valid JSON document"
    type = string
}