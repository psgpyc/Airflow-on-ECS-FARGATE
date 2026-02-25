output "ecs_fargate_cloudwatch_log_group_arn" {

    value = aws_cloudwatch_log_group.ecs_fargate_cloudwatch_log_group.arn
    description = "Log Group for ECS Fargate"

  
}