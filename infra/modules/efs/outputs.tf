output "efs_file_system_id" {
  description = "EFS file system ID."
  value       = aws_efs_file_system.this.id
}

output "efs_file_system_arn" {
  description = "EFS file system ARN."
  value       = aws_efs_file_system.this.arn
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


output "efs_access_point_ids" {
  description = "Map of EFS access point IDs keyed by access_point_config keys (e.g., ap_dags, ap_logs)."
  value = {
    for k, ap in aws_efs_access_point.this: k => ap.id
  }
  
}

output "efs_access_point_arns" {
  description = "Map of EFS access point ARNs keyed by access_point_config keys."
  value       = { for k, ap in aws_efs_access_point.this : k => ap.arn }
}

output "efs_access_point_paths" {
  description = "Map of access point root paths keyed by access_point_config keys."
  value       = { for k, cfg in var.access_point_config : k => cfg }
}

