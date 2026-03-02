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


# EFS

module "efs" {

  source = "./modules/efs"

  creation_token = var.creation_token

  mount_target_subnet_ids = [for k,v in module.vpc_subnet.private_subnet_ids: v]

  mount_target_sec_group_id = [module.security_groups["efs"].security_group_id]

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
