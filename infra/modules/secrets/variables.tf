variable "secret_name" {
  type        = string
  nullable    = false
  description = "Name of the secret in Secrets Manager."

  validation {
    condition     = length(trimspace(var.secret_name)) > 0
    error_message = "secret_name cannot be empty."
  }
}

variable "description" {
  type        = string
  nullable    = false
  description = "Description for the secret."
  default     = "Database connection details."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "description cannot be empty."
  }
}

variable "kms_key_id" {

  type        = string
  nullable    = true
  description = "Optional KMS key ID/ARN for encrypting the secret. Leave null to use aws/secretsmanager."
  default     = null
}

variable "db_host" {
  type        = string
  nullable    = false
  description = "Database hostname (e.g., RDS endpoint)."

  validation {
    condition     = length(trimspace(var.db_host)) > 0
    error_message = "db_host cannot be empty."
  }
}

variable "db_port" {
  type        = number
  nullable    = false
  description = "Database port (Postgres default 5432)."
  default     = 5432

  validation {
    condition     = var.db_port >= 1 && var.db_port <= 65535
    error_message = "db_port must be a valid TCP port (1-65535)."
  }
}

variable "db_name" {
  type        = string
  nullable    = false
  description = "Database name."

  validation {
    condition     = length(trimspace(var.db_name)) > 0
    error_message = "db_name cannot be empty."
  }
}

variable "db_username" {
  type        = string
  nullable    = false
  description = "Database username."

  validation {
    condition     = length(trimspace(var.db_username)) > 0
    error_message = "db_username cannot be empty."
  }
}

variable "db_password" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Database password."

  validation {
    condition     = length(var.db_password) >= 12
    error_message = "db_password must be at least 12 characters."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply."
  default     = {}

  validation {
    condition     = length(keys(var.tags)) >= 0
    error_message = "tags must be a map of strings."
  }
}