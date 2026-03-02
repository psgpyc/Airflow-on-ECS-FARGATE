
# TASK DEFINITIONS

module "airflow_init_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-init-task-def"

  container_definitions = templatefile("./policies/task_definitions/airflow_init_container_def.json.tpl", {
    airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
    airflow_web_secrets_arn = module.secrets_airflow.secret_arn
  })

}



module "airflow_webserver_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-web-task-def"

  efs_volumes_config = local.airflow_webserver_efs_volume_config

  container_definitions = templatefile("./policies/task_definitions/airflow_web_task_def.json.tpl", {
    airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
    airflow_web_secrets_arn = module.secrets_airflow.secret_arn
    port_name = var.service_connect_port_name
    execution_api_server_url = "http://${var.service_connect_dns_name}:8080/execution/"
    mount_points = jsonencode(local.mount_points)

  })
  
}

module "airflow_scheduler_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-scheduler-task-def"

  efs_volumes_config = local.airflow_webserver_efs_volume_config

    container_definitions = templatefile("./policies/task_definitions/airflow_scheduler_container_def.json.tpl", {
      airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
      airflow_web_secrets_arn = module.secrets_airflow.secret_arn
      port_name = var.service_connect_port_name
      mount_points = jsonencode(local.mount_points)
      celery_broker_url = "redis://:@${module.redis_for_airflow.redis_endpoint}:${module.redis_for_airflow.redis_port}/0"
      execution_api_server_url = "http://${var.service_connect_dns_name}:8080/execution/"
  })
  
}

module "airflow_dag_processor_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-dag-processor-task-def"

  efs_volumes_config = local.airflow_webserver_efs_volume_config

    container_definitions = templatefile("./policies/task_definitions/airflow_dag_processor_container_def.json.tpl", {
      airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
      airflow_web_secrets_arn = module.secrets_airflow.secret_arn
      port_name = var.service_connect_port_name
      mount_points = jsonencode(local.mount_points)
      celery_broker_url = "redis://:@${module.redis_for_airflow.redis_endpoint}:${module.redis_for_airflow.redis_port}/0"
      execution_api_server_url = "http://${var.service_connect_dns_name}:8080/execution/"
  })
  
}


module "airflow_triggerer_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-triggerer-task-def"

  efs_volumes_config = local.airflow_webserver_efs_volume_config

    container_definitions = templatefile("./policies/task_definitions/airflow_triggerer_container_def.json.tpl", {
      airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
      airflow_web_secrets_arn = module.secrets_airflow.secret_arn
      port_name = var.service_connect_port_name
      mount_points = jsonencode(local.mount_points)
      celery_broker_url = "redis://:@${module.redis_for_airflow.redis_endpoint}:${module.redis_for_airflow.redis_port}/0"
      execution_api_server_url = "http://${var.service_connect_dns_name}:8080/execution/"
  })
  
}

module "airflow_celery_worker_task_definition" {

  source = "./modules/ecs_task_definition"

  execution_role_arn = module.ecs_task_execution_iam.iam_role_arn

  task_role_arn = module.ecs_task_role_iam.iam_role_arn

  family = "airflow-celery-worker-task-def"

  memory = 4096

  efs_volumes_config = local.airflow_webserver_efs_volume_config

    container_definitions = templatefile("./policies/task_definitions/airflow_celery_worker_container_def.json.tpl", {
      airflow_sql_alchemy_conn_arn = module.secrets_db.secret_arn
      airflow_web_secrets_arn = module.secrets_airflow.secret_arn
      port_name = var.service_connect_port_name
      mount_points = jsonencode(local.mount_points)
      celery_broker_url = "redis://:@${module.redis_for_airflow.redis_endpoint}:${module.redis_for_airflow.redis_port}/0"
      execution_api_server_url = "http://${var.service_connect_dns_name}:8080/execution/"
  })
  
}
