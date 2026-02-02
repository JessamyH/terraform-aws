// Public subnet IDs for NAT Gateway and ALB (must be in at least two AZs)
variable "public_subnet_ids" {
  description = "Public subnet IDs for NAT Gateway and ALB"
  type        = list(string)
  default = [
    "subnet-0a05dfbfa9b02eb45", // Sample-subnet-public1-ap-southeast-2a
    "subnet-044bb7e2c10d0b1ee"  // Sample-subnet-public2
  ]
}

// VPC ID for all resources
variable "vpc_id" {
  description = "VPC ID for EC2 and SG (Sample-vpc, private subnet)"
  type        = string
  default     = "vpc-0a775837570253930"
}

// Private subnet ID for EC2 instance
variable "subnet_id" {
  description = "Subnet ID for EC2 (Sample-subnet-private1-ap-southeast-2a, private subnet)"
  type        = string
  default     = "subnet-089bf9a6ed97aad05"
}

// Whether to assign public IP to EC2 (should be false for private subnet)
variable "associate_public_ip" {
  description = "Whether to assign public IP to EC2 (private subnet, so disable)"
  type        = bool
  default     = false
}
