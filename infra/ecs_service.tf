resource "aws_ecs_service" "airflow_web" {

  name = "${var.name}-airflow-web-one"
  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_webserver_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = true

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # IMPORTANT: because the target group health-check might fail while Airflow boots / DB connects
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = [for k, v in module.vpc_subnet.private_subnet_ids: v]
    security_groups  = [module.security_groups["airflow_web"].security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "airflow-web"
    container_port   = "8080"
  }

  # Ensures the listener exists before ECS tries to attach the service to the TG.
  depends_on = [module.alb]

  tags = { Name = "${var.name}-airflow-web" }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.this.arn

    service {
      # MUST match container portMappings[].name in task definition
      port_name = var.service_connect_port_name

      client_alias {
        # airflow-web
        dns_name = var.service_connect_dns_name
        port = var.service_connect_client_port
      }
    }

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = var.service_connect_log_group_name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = var.service_connect_log_stream_prefix
      }
    }
  }

  
}


resource "aws_ecs_service" "airflow_scheduler" {

  name = "${var.name}-airflow-scheduler-one"

  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_scheduler_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"
  
  enable_execute_command = true

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # IMPORTANT: because the target group health-check might fail while Airflow boots / DB connects
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = [for k, v in module.vpc_subnet.private_subnet_ids: v]
    security_groups  = [module.security_groups["airflow_scheduler"].security_group_id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.this.arn

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = var.service_connect_log_group_name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "scheduler-sc"
      }
    }
  }



  tags = { Name = "${var.name}-airflow-scheduler" }
  
}

resource "aws_ecs_service" "airflow_dag_processor" {

  name = "${var.name}-airflow-dag-processor-one"

  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_dag_processor_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = true

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # IMPORTANT: because the target group health-check might fail while Airflow boots / DB connects
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = [for k, v in module.vpc_subnet.private_subnet_ids: v]
    security_groups  = [module.security_groups["airflow_scheduler"].security_group_id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.this.arn

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = var.service_connect_log_group_name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "scheduler-dp"
      }
    }
  }



  tags = { Name = "${var.name}-airflow-dag-processor" }
  
}

resource "aws_ecs_service" "airflow_triggerer" {

  name = "${var.name}-airflow-triggerer"

  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_triggerer_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = true


  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # IMPORTANT: because the target group health-check might fail while Airflow boots / DB connects
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = [for k, v in module.vpc_subnet.private_subnet_ids: v]
    security_groups  = [module.security_groups["airflow_scheduler"].security_group_id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.this.arn

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = var.service_connect_log_group_name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "scheduler-tg"
      }
    }
  }



  tags = { Name = "${var.name}-airflow-triggerer" }
  
}

resource "aws_ecs_service" "airflow_celery_worker" {

  name = "${var.name}-airflow-celery-workers"

  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_celery_worker_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = true


  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  # IMPORTANT: because the target group health-check might fail while Airflow boots / DB connects
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = [for k, v in module.vpc_subnet.private_subnet_ids: v]
    security_groups  = [module.security_groups["airflow_worker"].security_group_id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.this.arn

    service {
      # MUST match container portMappings[].name in task definition
      port_name = "worker-logs"
      discovery_name = "worker"

      client_alias {

        dns_name = "worker"
        port = 8793
      }
    }

    log_configuration {
      log_driver = "awslogs"
      options = {
        awslogs-group         = var.service_connect_log_group_name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = var.service_connect_log_stream_prefix
      }
    }
  }



  tags = { Name = "${var.name}-airflow-celery-worker" }
  
}