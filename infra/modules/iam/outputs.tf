output "iam_role_id" {
  description = "ID of the IAM role."
  value       = aws_iam_role.this.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.this.name
}

output "iam_role_unique_id" {
  description = "Stable unique ID of the IAM role."
  value       = aws_iam_role.this.unique_id
}

output "inline_policy_id" {
  description = "ID of the inline role policy resource."
  value       = aws_iam_role_policy.this.id
}

output "inline_policy_name" {
  description = "Name of the inline role policy."
  value       = aws_iam_role_policy.this.name
}