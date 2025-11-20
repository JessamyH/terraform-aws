variable "public_subnet_id" {
  description = "Public subnet ID for NAT Gateway"
  type        = string
  default     = "subnet-0a05dfbfa9b02eb45"
}
variable "vpc_id" {
  description = "VPC ID for EC2 and SG (Sample-vpc, private subnet)"
  type        = string
  default     = "vpc-0a775837570253930"
}

variable "subnet_id" {
  description = "Subnet ID for EC2 (Sample-subnet-private1-ap-southeast-2a, private subnet)"
  type        = string
  default     = "subnet-089bf9a6ed97aad05"
}

variable "associate_public_ip" {
  description = "Whether to assign public IP to EC2 (private subnet, so disable)"
  type        = bool
  default     = false
}
