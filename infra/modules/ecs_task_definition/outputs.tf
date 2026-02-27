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
