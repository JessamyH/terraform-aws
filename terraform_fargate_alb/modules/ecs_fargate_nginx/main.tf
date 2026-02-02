resource "aws_ecs_cluster" "jessamy_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_exec_role" {
  name = "${var.project_name}-task-exec-role-jessamy"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "jessamy_task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "node-app-jessamy"
      image     = var.node_app_image
      essential = true
      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "PORT", value = "3000" },
        { name = "SERVICE_NAME", value = "nginx-jessamy-app" }
      ]
      portMappings = [
        { containerPort = var.node_app_port, protocol = "tcp" }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1"]
        interval    = 15
        timeout     = 5
        retries     = 5
        startPeriod = 30
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/node-app-jessamy"
          "awslogs-region"        = "ap-southeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
    {
      name      = "nginx-proxy-jessamy"
      image     = var.nginx_image
      essential = true
      environment = [
        { name = "SERVICE_NAME", value = "nginx-jessamy-app" }
      ]
      portMappings = [
        { containerPort = var.nginx_port, hostPort = var.nginx_port, protocol = "tcp" }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost/health || exit 1"]
        interval    = 15
        timeout     = 5
        retries     = 5
        startPeriod = 30
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/nginx-proxy-jessamy"
          "awslogs-region"        = "ap-southeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "jessamy_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.jessamy_cluster.id
  task_definition = aws_ecs_task_definition.jessamy_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.nginx_container_name
    container_port   = var.nginx_port
  }

}
