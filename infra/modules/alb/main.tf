resource "aws_lb" "this" {

    name = "${var.name}-lb"
    internal = var.is_internal

    load_balancer_type = var.load_balancer_type

    security_groups = var.security_groups

    subnets = var.subnets

    enable_deletion_protection = false

    ip_address_type = var.ip_address_type

    idle_timeout = var.idle_timeout

    drop_invalid_header_fields = true


    dynamic "access_logs" {

        for_each = var.is_access_log_enabled ? [1]: []

        content {
          bucket = var.bucket_id
          prefix = var.bucket_prefix
          enabled = true
        }
      
    }

    tags = merge(
        var.tags,
        {
            Name= "${var.name}-lb"
        }
    )

}

resource "aws_lb_target_group" "this" {

    name = "${var.name}-target-group"

    # port and protocol used by ALB when sending traffic to target
    port = var.target_g_port
    protocol = var.target_g_protocol

    # "ip" for fargate, "instance" for ec2
    target_type = var.target_type

    vpc_id = var.target_g_vpc_id


    health_check {
        path                = var.health_check_path
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = merge(
        var.tags, 
        {
            Name = "${var.name}_target_group"
        }
    )

}

resource "aws_lb_listener" "http" {

    load_balancer_arn = aws_lb.this.arn

    # ALB listened on port 80 and uses HTTP. 
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.this.arn
    }

  
}

