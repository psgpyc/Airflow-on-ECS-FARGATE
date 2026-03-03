
# ECS

module "ecs_task_execution_iam" {

  source = "./modules/iam"

  iam_role_name = "${var.name}_ecs_task_execution_role"

  iam_role_description = var.ecs_task_execution_role_description

  assume_role_policy = file("./policies/task_execution_role_assume_role.json")

  iam_role_policy = templatefile("./policies/task_execution_role_policy.json.tpl", {
    ecr_repo_arn                         = module.ecr.ecr_repo_arn
    cloudwatch_ecs_log_group_arn         = aws_cloudwatch_log_group.ecs_fargate_cloudwatch_log_group.arn
    cloudwatch_ecs_connect_log_group_arn = aws_cloudwatch_log_group.ecs_airflow_web_service_connect_log_group.arn
    airflow_web_secrets_arn              = module.secrets_airflow.secret_arn
    airflow_db_secrets_arn               = module.secrets_db.secret_arn
  })

}


module "ecs_task_role_iam" {

  source = "./modules/iam"

  iam_role_name = "${var.name}_ecs_task_role"

  iam_role_description = var.ecs_task_role_description

  assume_role_policy = file("./policies/task_assume_role.json")

  iam_role_policy = templatefile("./policies/task_policy.json.tpl", {
    secrets_arn = module.secrets_db.secret_arn
  })

}