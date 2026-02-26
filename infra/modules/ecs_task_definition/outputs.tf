output "task_definition_arn" {
  description = "ARN of the created ECS task definition revision."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Task definition family."
  value       = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  description = "Task definition revision number."
  value       = aws_ecs_task_definition.this.revision
}

output "task_definition_arn_without_revision" {
  description = "Task definition ARN without revision suffix."
  value       = aws_ecs_task_definition.this.arn_without_revision
}

# Volume (EFS) — outputs

output "volume_enabled" {
  description = "Whether the task definition includes the EFS volume block."
  value       = var.has_volume
}

output "volume_name" {
  description = "Task-level volume name (used by containers as mountPoints.sourceVolume)."
  value       = var.volume_name
}

output "efs_file_system_id" {
  description = "EFS file system ID configured for the task volume (if enabled)."
  value       = var.has_volume ? var.efs_file_system_id : null
}

output "efs_access_point_id" {
  description = "EFS access point ID configured for the task volume (if enabled)."
  value       = var.has_volume ? var.efs_access_point_id : null
}