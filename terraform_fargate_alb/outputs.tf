
// ALB ARN
output "alb_arn" {
  value = module.alb.alb_arn
}

// ALB DNS name
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

// Target Group ARN
output "tg_arn" {
  value = module.alb.tg_arn
}

// ALB Security Group ID
output "alb_sg_id" {
  value = module.security_group.alb_sg_id
}

// EC2 Security Group ID
output "ec2_sg_id" {
  value = module.security_group.ec2_sg_id
}
