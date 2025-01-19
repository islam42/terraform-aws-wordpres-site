# aws_lb

resource "aws_lb" "nginx-lb" {
  name               = "${local.name_prefix}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  #   subnets                          = aws_subnet.subnets[*].id
  subnets                          = module.vpc.public_subnets
  enable_deletion_protection       = false
  enable_http2                     = true
  idle_timeout                     = 60
  enable_cross_zone_load_balancing = true

  tags = local.common_tags

  access_logs {
    bucket  = module.web_app_s3.website_bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

}

# aws_lb_target_group

resource "aws_lb_target_group" "nginx-tg" {
  name     = "${local.name_prefix}-app-tg"
  port     = 80
  protocol = "HTTP"
  #   vpc_id      = aws_vpc.vpc1.id
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags

}

# aws_lb_listener

resource "aws_lb_listener" "nginx-lb-listener" {
  load_balancer_arn = aws_lb.nginx-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }

  tags = local.common_tags

}

# aws_lb_target_group_attachment

resource "aws_lb_target_group_attachment" "nginx-tg-attachments" {
  count            = var.aws_instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginx-instances[count.index].id
  port             = 80
}