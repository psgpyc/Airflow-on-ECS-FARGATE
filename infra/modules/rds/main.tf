resource "aws_db_subnet_group" "this" {

    name = var.name
    description = var.description
    subnet_ids = var.subnet_ids

    tags = merge(
        var.tags, 
        {
            Name = var.name
            Type = "RDS"
        }
    )
}

resource "aws_db_instance" "this" {

  identifier = "${var.name}-airflow-db"

  engine         = "postgres"
  engine_version = var.pg_engine_version

  instance_class    = var.pg_instance_class
  allocated_storage = var.pg_allocated_storage_gb

  db_name  = var.pg_db_name
  username = var.pg_master_username
  password = var.pg_master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.list_of_rds_security_group_ids

  publicly_accessible = var.publicly_accessible

  # keeping it single az, no snapshot to reduce cost for portfolio
  multi_az = var.multi_az

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection
}