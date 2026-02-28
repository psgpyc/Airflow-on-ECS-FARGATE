output "redis_cluster_id" {
  description = "ElastiCache cluster ID."
  value       = aws_elasticache_cluster.this.id
}

output "redis_arn" {
  description = "ElastiCache cluster ARN."
  value       = aws_elasticache_cluster.this.arn
}

output "redis_endpoint" {
  description = "Redis node endpoint hostname (single node: cache_nodes[0].address)."
  value       = aws_elasticache_cluster.this.cache_nodes[0].address
}

output "redis_port" {
  description = "Redis port."
  value       = aws_elasticache_cluster.this.cache_nodes[0].port
}

output "redis_subnet_group_name" {
  description = "ElastiCache subnet group name."
  value       = aws_elasticache_subnet_group.this.name
}