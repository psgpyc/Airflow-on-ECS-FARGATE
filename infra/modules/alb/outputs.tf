output "lb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "Canonical hosted zone ID of the ALB (useful for Route53 alias records)."
  value       = aws_lb.this.zone_id
}

output "lb_name" {
  description = "Name of the ALB."
  value       = aws_lb.this.name
}

output "target_group_arn" {
  description = "ARN of the ALB target group."
  value       = aws_lb_target_group.this.arn
}

output "target_group_name" {
  description = "Name of the ALB target group."
  value       = aws_lb_target_group.this.name
}

output "listener_arn" {
  description = "ARN of the HTTP listener."
  value       = aws_lb_listener.http.arn
}