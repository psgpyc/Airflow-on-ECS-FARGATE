variable "name" {
  type        = string
  nullable    = false
  description = "Base name used to build the ECR repository name (e.g., <name>/airflow)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the ECR repository."
}