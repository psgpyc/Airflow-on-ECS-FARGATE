# ECR REPOSITORY

  module "ecr" {

    source = "./modules/ecr"

    name = var.ecr_name

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