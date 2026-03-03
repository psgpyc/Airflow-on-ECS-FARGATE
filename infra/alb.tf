module "alb" {

  source = "./modules/alb"
  name   = var.alb_name

  # false
  is_internal = var.is_internal

  # application
  load_balancer_type = var.load_balancer_type

  idle_timeout = var.idle_timeout

  is_access_log_enabled = var.is_access_log_enabled

  security_groups = [module.security_groups["alb_public"].security_group_id]

  subnets = [for k, v in module.vpc_subnet.public_subnet_ids : v]

  # target group

  target_g_vpc_id = module.vpc_subnet.vpc_id

  target_g_port     = var.target_g_port
  target_g_protocol = var.target_g_protocol
  target_type       = var.target_type
  health_check_path = var.health_check_path


}
