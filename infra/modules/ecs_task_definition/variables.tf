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

variable "efs_volumes_config" {
  description = "Map of EFS volumes keyed by volume name. Each entry defines file system and access point."
  type = map(object({
    file_system_id  = string
    access_point_id = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.efs_volumes_config :
      can(regex("^fs-[0-9a-f]+$", v.file_system_id)) &&
      can(regex("^fsap-[0-9a-f]+$", v.access_point_id))
    ])
    error_message = "Each efs_volumes entry must contain valid fs- and fsap- IDs."
  }
}

# Container definitions

variable "container_definitions" {
    description = "A list of valid container definitions provided as a single valid JSON document"
    type = string

    validation {
      condition     = can(jsondecode(var.container_definitions))
      error_message = "container_definitions must be valid JSON."
    }
}