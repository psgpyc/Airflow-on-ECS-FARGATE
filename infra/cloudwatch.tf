
# CLOUDWATCH log group

resource "aws_cloudwatch_log_group" "ecs_fargate_cloudwatch_log_group" {

  name = "/ecs/${var.name}/airflow"

  retention_in_days = 14

  tags = {
    Name = "/ecs/${var.name}/airflow"
  }

}

resource "aws_cloudwatch_log_group" "ecs_airflow_web_service_connect_log_group" {

  name = var.service_connect_log_group_name

  retention_in_days = 14

  tags = {
    Name = var.service_connect_log_group_name
  }

}
