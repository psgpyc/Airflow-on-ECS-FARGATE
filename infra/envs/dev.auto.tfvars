name = "aede"

cidr_block = "10.0.0.0/16"

subnet_config = {
  public_a = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "eu-west-2a"
    type              = "public"
    tags = {
      type = "public"
      az   = "a"
    }
  }

  public_b = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "eu-west-2b"
    type              = "public"
    tags = {
      type = "public"
      az   = "b"
    }
  }

  private_a = {
    cidr_block        = "10.0.101.0/24"
    availability_zone = "eu-west-2a"
    type              = "private"
    tags = {
      type = "private"
      az   = "a"
    }
  }

  private_b = {
    cidr_block        = "10.0.102.0/24"
    availability_zone = "eu-west-2b"
    type              = "private"
    tags = {
      type = "private"
      az   = "b"
    }
  }
}

# SECURITY GROUP

sec_group_config = {
  alb_public = {
    sec_group_name        = "secg-alb-public"
    sec_group_description = "Public ALB security group (internet-facing)"
  }

  airflow_web = {
    sec_group_name        = "secg-airflow-web"
    sec_group_description = "Airflow webserver security group (private, behind ALB)"
  }

  airflow_scheduler = {
    sec_group_name        = "secg-airflow-scheduler"
    sec_group_description = "Airflow scheduler security group (private)"
  }

  airflow_worker = {
    sec_group_name        = "secg-airflow-worker"
    sec_group_description = "Airflow worker security group (private)"
  }

  redis = {
    sec_group_name        = "secg-redis"
    sec_group_description = "Redis broker security group (private)"
  }

  rds = {
    sec_group_name        = "secg-rds-postgres"
    sec_group_description = "Postgres metadata DB security group (private)"
  }

  flower = {
    sec_group_name        = "secg-airflow-flower"
    sec_group_description = "Flower monitoring security group (private; optional via ALB)"
  }

  efs = {
    sec_group_name        = "secg-airflow-efs-tg",
    sec_group_description = "EFS mount target security group. Accept TCP on 2049 from Airflow Security Groups"
  }
}

# ALB

alb_name = "aede"


# RDS


db_subnet_group_name        = "airflow-db-subnet-group"
db_subnet_group_description = "DB subnet group for Airflow RDS PostgreSQL (private subnets across 2 AZs)."

pg_instance_class       = "db.t4g.micro"
pg_engine_version       = "17.8"
pg_allocated_storage_gb = 20

pg_db_name         = "airflow"
pg_master_username = "airflow"
# pg_master_password moved to actions secrets

# SECRETS MANAGER

secret_name            = "airflow-rds-secrets"
airflow_secret_name    = "airflow-web-secrets"
airflow_admin_username = "psgpyc"

# airflow_admin_password moved to actions secrets

# ECR REPO

ecr_name = "airflow-image-repo"

# IAM

ecs_task_execution_role_description = "IAM role for ECS farget agents to assume"
ecs_task_role_description           = "IAM role for ECS fareget Tasks"

# EFS

creation_token = "airflow-aede-efs"

# CLOUDMAP NAMES

cloudmap_namespace_name        = "aede"
cm_name                        = "aedecm"
cloudmap_namespace_description = "Service discovery namespace for ECS Service Connect (Airflow on ECS Fargate)."

# REDIS
redis_cluster_name = "aede-airflow"

# SERVICE CONNECT

service_connect_port_name         = "airflow-api"
service_connect_dns_name          = "airflow-web"
service_connect_client_port       = 8080
service_connect_log_group_name    = "/ecs/aede/service-connect"
service_connect_log_stream_prefix = "airflow-web-sc"