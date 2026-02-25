output "efs_file_system_id" {
  description = "EFS file system ID."
  value       = aws_efs_file_system.this.id
}

output "efs_file_system_arn" {
  description = "EFS file system ARN."
  value       = aws_efs_file_system.this.arn
}

output "efs_access_point_dags_id" {
  description = "EFS access point ID for DAGs."
  value       = aws_efs_access_point.dags.id
}

output "efs_access_point_dags_arn" {
  description = "EFS access point ARN for DAGs."
  value       = aws_efs_access_point.dags.arn
}

output "efs_mount_targets" {
  description = "Map of subnet_id -> mount target attributes."
  value = {
    for subnet_id, mt in aws_efs_mount_target.this :
    subnet_id => {
      id               = mt.id
      dns_name         = mt.dns_name
      network_interface_id = mt.network_interface_id
    }
  }
}