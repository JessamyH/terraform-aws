variable "nginx_container_name" {
	description = "Nginx container name for ECS service load balancer"
	type        = string
	default     = "nginx-proxy-jessamy"
}
variable "node_app_image" {
	description = "Node app image name"
	type        = string
	default     = "jessamy/node-app-jessamy:latest"
}

variable "nginx_image" {
	description = "Nginx proxy image name"
	type        = string
	default     = "jessamy/nginx-proxy-jessamy:latest"
}

variable "node_app_port" {
	description = "Node app container port"
	type        = number
	default     = 3000
}

variable "nginx_port" {
	description = "Nginx proxy container port"
	type        = number
	default     = 80
}
variable "region" { type = string }
variable "project_name" { type = string }
variable "cluster_name" { type = string }
variable "task_family" { type = string }
variable "cpu" { type = string }
variable "memory" { type = string }
variable "container_name" { type = string }
variable "service_name" { type = string }
variable "desired_count" { type = number }
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "target_group_arn" { type = string }
