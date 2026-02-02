resource "aws_lb" "jessamy_alb" {
  name               = "alb-jessamy"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "alb-jessamy"
  }
}

resource "aws_lb_target_group" "jessamy_tg" {
  name     = "tg-jessamy"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "tg-jessamy"
  }
}

resource "aws_lb_listener" "jessamy_listener" {
  load_balancer_arn = aws_lb.jessamy_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jessamy_tg.arn
  }
}

