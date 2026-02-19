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