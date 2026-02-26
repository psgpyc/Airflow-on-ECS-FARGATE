resource "aws_ecs_task_definition" "this" {

    family = var.family

    execution_role_arn = var.execution_role_arn
    task_role_arn = var.task_role_arn

    # only support awsvpc
    network_mode = "awsvpc"

    # only supports FARGATE
    requires_compatibilities = ["FARGATE"]

    cpu = var.cpu
    memory = var.memory

    runtime_platform {
      cpu_architecture = var.cpu_architecture
      operating_system_family = "LINUX"
    }

    # default is 20GIB for Fargate
    dynamic "ephemeral_storage" {
        for_each = var.ephemeral_storage_gib == null ? []:[1]

        content {
          size_in_gib = var.ephemeral_storage_gib
        }
      
    }

    dynamic "volume" {
      # only supports efs volume
      # currently setting to only one.
      for_each = var.has_volume == false ? [] : [1]

      content {

        name = var.volume_name

        efs_volume_configuration {
          file_system_id = var.efs_file_system_id

          # setting to '/', overridden by accesspoint definition
          root_directory = "/"

          # ENABLED required when using access point
          transit_encryption = "ENABLED"

          authorization_config {
            access_point_id = var.efs_access_point_id

            # Sec Group & Access point based control, no need for IAM currentlyare 
            iam = "DISABLED"
          }
          
        }
        
      }
      
    }

    container_definitions = var.container_definitions

    tags = merge(var.tags, { Name = var.family })
  
}