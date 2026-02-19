output "vpc_id" {
  description = "VPC id."
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "Internet Gateway id."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT Gateway id."
  value       = aws_nat_gateway.this.id
}

output "nat_eip_public_ip" {
  description = "Public IP of the NAT Gateway EIP."
  value       = aws_eip.nat.public_ip
}

output "public_subnet_ids" {
  description = "Public subnet ids (for ALB, NAT placement)."
  value       = local.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet ids (for ECS tasks, RDS/Redis)."
  value       = local.private_subnet_ids
}

output "subnet_ids_by_key" {
  description = "Subnet ids keyed by your for_each keys (e.g., public_a, private_b)."
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "public_route_table_id" {
  description = "Public route table id."
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "Private route table id."
  value       = aws_route_table.private_rt.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}