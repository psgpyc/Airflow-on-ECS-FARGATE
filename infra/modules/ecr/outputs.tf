output "ecr_repo_arn" {
  value       = aws_ecr_repository.this.arn
  description = "ARN of the Airflow ECR repository."
}

output "ecr_repo_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "ECR repository URL (use this as the image repo when you push)."
}