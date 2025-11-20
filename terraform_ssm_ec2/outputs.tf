output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ssm_demo.private_ip
}
output "instance_id" {
  value = aws_instance.ssm_demo.id
}

output "instance_public_ip" {
  value       = aws_instance.ssm_demo.public_ip
  description = "Public IP (if assigned)"
}

output "ssm_instance_profile" {
  value = aws_iam_instance_profile.ssm_profile.name
}
