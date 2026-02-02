// Private subnet for EC2 instance
variable "subnet_id" {
  type = string
}

// Whether to assign public IP (should be false for private subnet)
variable "associate_public_ip" {
  type = bool
}

// Security Group ID for EC2 instance
variable "ec2_sg_id" {
  type = string
}

// Target Group ARN for ALB registration
variable "tg_arn" {
  type = string
}
