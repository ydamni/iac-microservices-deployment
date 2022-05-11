### Network resources

resource "aws_vpc" "iac-vpc" {
  cidr_block           = "192.168.42.0/24"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "iac-vpc"
  }
}

resource "aws_subnet" "iac-subnet-public" {
  vpc_id                  = aws_vpc.iac-vpc.id
  cidr_block              = "192.168.42.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "iac-subnet-public"
  }
}

resource "aws_internet_gateway" "iac-igw" {
  vpc_id = aws_vpc.iac-vpc.id
  tags = {
    Name = "iac-igw"
  }
}

resource "aws_route_table" "iac-rtb-public" {
  vpc_id = aws_vpc.iac-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac-igw.id
  }
  tags = {
    Name = "iac-rtb-public"
  }
}

resource "aws_route_table_association" "iac-rtb-association" {
  subnet_id      = aws_subnet.iac-subnet-public.id
  route_table_id = aws_route_table.iac-rtb-public.id
}

resource "aws_security_group" "iac-sg-allow-http" {
  name   = "iac-sg-allow-http"
  vpc_id = aws_vpc.iac-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "iac-sg-allow-http"
  }
}


### ECS resources

resource "aws_ecs_cluster" "iac-cluster" {
  name = "iac-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "iac-provider" {
  cluster_name       = aws_ecs_cluster.iac-cluster.name
  capacity_providers = ["FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_task_definition" "iac-td-mysql-phpmyadmin" {
  family                   = "iac-td-mysql-phpmyadmin"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions = jsonencode([
    {
      name      = "mysql"
      image     = "docker.io/mysql:latest"
      cpu       = 256
      memory    = 768
      essential = true
      environment = [
        {
          name  = "MYSQL_ROOT_PASSWORD"
          value = var.mysql_root_password
        }
      ]
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ]
    },
    {
      name      = "phpmyadmin"
      image     = "docker.io/phpmyadmin:latest"
      cpu       = 256
      memory    = 256
      essential = true
      environment = [
        {
          name  = "PMA_HOST"
          value = "127.0.0.1"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "mysql-phpmyadmin" {
  name            = "mysql-phpmyadmin"
  cluster         = aws_ecs_cluster.iac-cluster.id
  task_definition = aws_ecs_task_definition.iac-td-mysql-phpmyadmin.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.iac-subnet-public.id]
    security_groups  = [aws_security_group.iac-sg-allow-http.id]
    assign_public_ip = true
  }
}
