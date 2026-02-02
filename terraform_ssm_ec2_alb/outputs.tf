// Private IP address of the EC2 instance
output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_instance.instance_private_ip
}

// EC2 instance ID
output "instance_id" {
  value = module.ec2_instance.instance_id
}

// SSM instance profile name
output "ssm_instance_profile" {
  value = module.ec2_instance.ssm_instance_profile
}

// EC2 public IP (should be null for private subnet)
output "instance_public_ip" {
  value       = null
  description = "Public IP (if assigned)"
}

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
