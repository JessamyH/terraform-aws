variable "node_app_image" {
  description = "Node app image name"
  type        = string
}

variable "nginx_image" {
  description = "Nginx proxy image name"
  type        = string
}

variable "node_app_port" {
  description = "Node app container port"
  type        = number
}

variable "nginx_port" {
  description = "Nginx proxy container port"
  type        = number
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-southeast-2"
}


// Public subnet IDs for NAT Gateway and ALB (must be in at least two AZs)

variable "public_subnet_ids" {
  description = "Public subnet IDs for NAT Gateway and ALB"
  type        = list(string)
}

// VPC ID for all resources

variable "vpc_id" {
  description = "VPC ID for EC2 and SG (Sample-vpc, private subnet)"
  type        = string
}

// Private subnet ID for EC2 instance

variable "subnet_id" {
  description = "Subnet ID for EC2 (Sample-subnet-private1-ap-southeast-2a, private subnet)"
  type        = string
}

// Whether to assign public IP to EC2 (should be false for private subnet)
variable "associate_public_ip" {
  description = "Whether to assign public IP to EC2 (private subnet, so disable)"
  type        = bool
  default     = false
}

# ECS Fargate variables
