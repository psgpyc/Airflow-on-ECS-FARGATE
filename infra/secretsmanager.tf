
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
    airflow_api_auth_jwt_secret = var.airflow_api_auth_jwt_secret
    airflow_core_fernet_key = var.airflow_core_fernet_key
    airflow_core_api_secret_key = var.airflow_core_api_secret_key

  })
  
}