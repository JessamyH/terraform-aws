// ALB ARN output
output "alb_arn" {
  value = aws_lb.jessamy_alb.arn
}

// Target Group ARN output
output "tg_arn" {
  value = aws_lb_target_group.jessamy_tg.arn
}
// ALB DNS name output
output "alb_dns_name" {
  value = aws_lb.jessamy_alb.dns_name
}
