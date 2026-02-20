output "db_instance_id" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the RDS DB instance."
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "RDS endpoint address (hostname)."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Database port."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Initial database name."
  value       = aws_db_instance.this.db_name
}

output "db_master_username" {
  description = "Master username (non-sensitive)."
  value       = aws_db_instance.this.username
}

output "db_subnet_group_name" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.this.name
}