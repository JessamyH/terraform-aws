// Private IP address of the EC2 instance
output "instance_private_ip" {
  value = aws_instance.ssm_demo.private_ip
}

// EC2 instance ID
output "instance_id" {
  value = aws_instance.ssm_demo.id
}

// SSM instance profile name
output "ssm_instance_profile" {
  value = aws_iam_instance_profile.ssm_profile.name
}
