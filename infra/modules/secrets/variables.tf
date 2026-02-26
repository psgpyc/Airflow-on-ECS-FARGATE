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


variable "secret_string" {
  type = string
  nullable = false
  description = "A secret json to store in vault"
  
  validation {
    condition = length(trimspace(var.secret_string)) > 0 && can(jsonencode(var.secret_string))
    error_message = "Must be a valid json"
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