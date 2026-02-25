resource "aws_secretsmanager_secret" "this" {
    name = var.secret_name
    description = var.description

    kms_key_id = var.kms_key_id

    tags = merge(
        var.tags, 
        {
            Name = "${var.secret_name}-sm"
        }
    )
  
}

resource "aws_secretsmanager_secret_version" "this" {

    secret_id = aws_secretsmanager_secret.this.id

    secret_string = jsonencode({
        host     = var.db_host
        port     = var.db_port
        dbname   = var.db_name
        username = var.db_username
        password = var.db_password
  })
  
}

