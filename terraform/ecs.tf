resource "aws_ecs_cluster" "cluster_trabajocloud" {
  name               = "cluster_trabajocloud"
  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}




resource "aws_ecs_task_definition" "taskc1" {
  family                   = "taskc1"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::037819712806:role/AmazonECSTaskExecutionRolePolicy"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name  = "cat"
      image = "037819712806.dkr.ecr.us-east-1.amazonaws.com/cats:latest"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }

  ])
}

resource "aws_ecs_task_definition" "taskd1" {
  family                   = "taskd1"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::037819712806:role/AmazonECSTaskExecutionRolePolicy"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name  = "dog"
      image = "037819712806.dkr.ecr.us-east-1.amazonaws.com/dogs:latest"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }

  ])
}


resource "aws_ecs_service" "ecs_taskc1" {
  name            = "ecs_taskc1"
  task_definition = aws_ecs_task_definition.taskc1.arn
  cluster         = aws_ecs_cluster.cluster_trabajocloud.id
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets         = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
    security_groups = [aws_security_group.allow_ssh_http.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.trabajo_tg.arn
    container_name   = "cat"
    container_port   = 80
  }

}


resource "aws_ecs_service" "ecs_taskd1" {
  name            = "ecs_taskd1"
  task_definition = aws_ecs_task_definition.taskd1.arn
  cluster         = aws_ecs_cluster.cluster_trabajocloud.id
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets         = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
    security_groups = [aws_security_group.allow_ssh_http.id]
    assign_public_ip = true
  }




  load_balancer {
    target_group_arn = aws_lb_target_group.trabajo_tg2.arn
    container_name   = "dog"
    container_port   = 80
  }

}