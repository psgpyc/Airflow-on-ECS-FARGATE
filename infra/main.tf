locals {
  efs_file_system_id = module.efs.efs_file_system_id

  airflow_webserver_efs_volume_config = {
    for k,v in module.efs.efs_access_point_ids: k => {
      file_system_id = local.efs_file_system_id
      access_point_id = v
    }

  }  

  mount_points = [
    for k, _ in local.airflow_webserver_efs_volume_config: {
      sourceVolume = k
      containerPath = "/opt/airflow/${k}" # dags/logs/plugins/config
      readOnly = false
    }
  ]

}


module "vpc_subnet" {

    source = "./modules/vpc"

    name = var.name

    cidr_block = var.cidr_block

    subnet_config = var.subnet_config

}

module "security_groups" {

    source = "./modules/security"

    for_each = var.sec_group_config

    sec_group_name = each.value.sec_group_name

    sec_group_description = each.value.sec_group_description

    sec_group_vpc_id = module.vpc_subnet.vpc_id
  
}

# ALB INGRESS FROM INTERNET

resource "aws_vpc_security_group_ingress_rule" "alb_http" {

  security_group_id = module.security_groups["alb_public"].security_group_id
  description = "HTTP from internet"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
    
}

resource "aws_vpc_security_group_ingress_rule" "this" {
    security_group_id = module.security_groups["alb_public"].security_group_id
    description = "HTTPS from internet"
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_ipv4 = "0.0.0.0/0"
  
}

# ALB to WEBSERVER : 8080 

resource "aws_vpc_security_group_ingress_rule" "airflow_web_from_alb" {

  security_group_id            = module.security_groups["airflow_web"].security_group_id
  referenced_security_group_id = module.security_groups["alb_public"].security_group_id

  description = "ALB to Airflow webserver"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}

# ALB to FLOWER : 5555

resource "aws_vpc_security_group_ingress_rule" "flower_from_alb" {
  security_group_id            = module.security_groups["flower"].security_group_id
  referenced_security_group_id = module.security_groups["alb_public"].security_group_id

  description = "ALB to FLOWER"
  from_port   = 5555
  to_port     = 5555
  ip_protocol = "tcp"
}

# REDIS INBOUND FROM WEBSERVER, SCHEDULER, WORKERS AND FLOWERS


resource "aws_vpc_security_group_ingress_rule" "redis_from_airflow_web" {
  security_group_id            = module.security_groups["redis"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_web"].security_group_id

  description = "secg-airflow-web to secg-redis (6379)"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_airflow_scheduler" {
  security_group_id            = module.security_groups["redis"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_scheduler"].security_group_id

  description = "secg-airflow-scheduler to secg-redis (6379)"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_airflow_worker" {
  security_group_id            = module.security_groups["redis"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_worker"].security_group_id

  description = "secg-airflow-worker to secg-redis (6379)"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_flower" {
  security_group_id            = module.security_groups["redis"].security_group_id
  referenced_security_group_id = module.security_groups["flower"].security_group_id

  description = "secg-airflow-flower to secg-redis (6379)"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}

# RDS INBOUND

resource "aws_vpc_security_group_ingress_rule" "rds_from_airflow_web" {
  security_group_id            = module.security_groups["rds"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_web"].security_group_id

  description = "secg-airflow-web to secg-rds-postgres (5432)"
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_airflow_scheduler" {
  security_group_id            = module.security_groups["rds"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_scheduler"].security_group_id

  description = "secg-airflow-scheduler to secg-rds-postgres (5432)"
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_airflow_worker" {
  security_group_id            = module.security_groups["rds"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_worker"].security_group_id

  description = "secg-airflow-worker to secg-rds-postgres (5432)"
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}


# EFS INGRESS AND EGRESS RULES

resource "aws_vpc_security_group_ingress_rule" "efs_from_airflow_web" {
  security_group_id = module.security_groups["efs"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_web"].security_group_id

  description = "secg-airflow-web to secg-airflow-efs-tg"
  from_port = 2049
  to_port = 2049
  ip_protocol = "tcp"
  
}

resource "aws_vpc_security_group_ingress_rule" "efs_from_airflow_scheduler" {
  security_group_id = module.security_groups["efs"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_scheduler"].security_group_id

  description = "secg-airflow-scheduler to secg-airflow-efs-tg"
  from_port = 2049
  to_port = 2049
  ip_protocol = "tcp"
  
}

resource "aws_vpc_security_group_ingress_rule" "efs_from_airflow_worker" {
  security_group_id = module.security_groups["efs"].security_group_id
  referenced_security_group_id = module.security_groups["airflow_worker"].security_group_id

  description = "secg-airflow-worker to secg-airflow-efs-tg"
  from_port = 2049
  to_port = 2049
  ip_protocol = "tcp"
  
}

# DEFAULT OUTBOUND 

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.sec_group_config

  security_group_id = module.security_groups[each.key].security_group_id

  description = "Default Outbound"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"

  
}

# ALB

module "alb" {

    source = "./modules/alb"
    name = var.alb_name

    # false
    is_internal = var.is_internal

    # application
    load_balancer_type = var.load_balancer_type   

    idle_timeout = var.idle_timeout

    is_access_log_enabled = var.is_access_log_enabled

    security_groups = [module.security_groups["alb_public"].security_group_id]

    subnets = [for k, v in module.vpc_subnet.public_subnet_ids: v]

    # target group

    target_g_vpc_id = module.vpc_subnet.vpc_id

    target_g_port = var.target_g_port
    target_g_protocol = var.target_g_protocol
    target_type = var.target_type
    health_check_path = var.health_check_path

  
}

# RDS

module "rds_pg" {

  source = "./modules/rds"

  name = var.db_subnet_group_name

  subnet_ids = [for k, v in module.vpc_subnet.private_subnet_ids: v]

  description = var.db_subnet_group_description

  pg_instance_class = var.pg_instance_class

  pg_engine_version = var.pg_engine_version

  pg_allocated_storage_gb = var.pg_allocated_storage_gb

  pg_db_name = var.pg_db_name

  pg_master_username = var.pg_master_username

  pg_master_password = var.pg_master_password

  list_of_rds_security_group_ids = [module.security_groups["rds"].security_group_id]

}

# SECRETS MANAGER


# db secrets
module "secrets_db" {

  source = "./modules/secrets"

  secret_name = var.secret_name

  secret_string = jsonencode({

    db_host = module.rds_pg.db_endpoint
    db_port = module.rds_pg.db_port
    db_name = module.rds_pg.db_name
    db_username = var.pg_master_username
    db_password = var.pg_master_password
    sql_alchemy_conn = format(
      "postgresql+psycopg2://%s:%s@%s:%s/%s",
      var.pg_master_username,
      urlencode(var.pg_master_password),
      module.rds_pg.db_endpoint,
      module.rds_pg.db_port,
      module.rds_pg.db_name
    )
    celery_backend_conn=format(
      "db+postgresql://%s:%s@%s:%s/%s",
      var.pg_master_username,
      urlencode(var.pg_master_password),
      module.rds_pg.db_endpoint,
      module.rds_pg.db_port,
      module.rds_pg.db_name

    )

  })
}

# airflow secrets

module "secrets_airflow" {
  source = "./modules/secrets"

  secret_name = var.airflow_secret_name

  secret_string = jsonencode({

    airflow_admin_username = var.airflow_admin_username
    airflow_admin_password = var.airflow_admin_password

  })
  
}

# ECR REPOSITORY

  module "ecr" {

    source = "./modules/ecr"

    name = var.ecr_name

}


# CLOUDWATCH log group

resource "aws_cloudwatch_log_group" "ecs_fargate_cloudwatch_log_group" {

  name              = "/ecs/${var.name}/airflow"

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


# EFS

module "efs" {

  source = "./modules/efs"

  creation_token = var.creation_token

  mount_target_subnet_ids = [for k,v in module.vpc_subnet.private_subnet_ids: v]

  mount_target_sec_group_id = [module.security_groups["efs"].security_group_id]

}

# ECS

module "ecs_task_execution_iam" {

  source = "./modules/iam"

  iam_role_name = "${var.name}_ecs_task_execution_role"

  iam_role_description = var.ecs_task_execution_role_description

  assume_role_policy = file("./policies/task_execution_role_assume_role.json")

  iam_role_policy = templatefile("./policies/task_execution_role_policy.json.tpl", {
    ecr_repo_arn = module.ecr.ecr_repo_arn
    cloudwatch_ecs_log_group_arn = aws_cloudwatch_log_group.ecs_fargate_cloudwatch_log_group.arn
    cloudwatch_ecs_connect_log_group_arn = aws_cloudwatch_log_group.ecs_airflow_web_service_connect_log_group.arn
    airflow_web_secrets_arn = module.secrets_airflow.secret_arn
    airflow_db_secrets_arn = module.secrets_db.secret_arn
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


resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
      Name = "${var.name}-cluster"
    }
  
}

# Cloud Map Namespace

# Namespace name used by ECS Service Connect for service discovery.
resource "aws_service_discovery_http_namespace" "this" {

  name = var.cloudmap_namespace_name

  description = var.cloudmap_namespace_description

  tags = {
      Name      = "${var.cm_name}-cloudmap-http-namespace"
      component = "service-discovery"
  }
  
}

# REDIS

module "redis_for_airflow" {
  source = "./modules/redis"

  redis_cluster_name = var.redis_cluster_name

  redis_private_subnet_ids = [for k, v in module.vpc_subnet.private_subnet_ids: v]

  redis_security_group_id = module.security_groups["redis"].security_group_id

  redis_node_type       = "cache.t3.micro"
  redis_num_cache_nodes = 1
  redis_port            = 6379
  apply_immediately     = true
  
}


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

resource "aws_ecs_service" "airflow_web" {

  name = "${var.name}-airflow-web-two"
  cluster = aws_ecs_cluster.this.arn

  task_definition = module.airflow_webserver_task_definition.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

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