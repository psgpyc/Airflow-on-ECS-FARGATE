resource "aws_ecr_repository" "this" {

    name = "${var.name}/airflow"

    # MUTABLE means tags (like :latest) can be overwritten.
    # IMMUTABLE means once a tag is pushed, it cannot be changed.
    image_tag_mutability = "MUTABLE"

    # Venurability scanning when an image is pushed.
    image_scanning_configuration {
      scan_on_push = true
    }

    tags = merge(
        var.tags, 
        {
            Name = var.name
        }
    )
  
}

resource "aws_ecr_lifecycle_policy" "airflow_keep_last" {

  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 20 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  depends_on = [ aws_ecr_repository.this ]
}