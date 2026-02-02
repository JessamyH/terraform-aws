// Public subnets for ALB (must be in at least two AZs)
variable "public_subnet_ids" {
  type = list(string)
}

// VPC where ALB and TG are deployed
variable "vpc_id" {
  type = string
}

// Security Group ID for ALB
variable "alb_sg_id" {
  type = string
}
