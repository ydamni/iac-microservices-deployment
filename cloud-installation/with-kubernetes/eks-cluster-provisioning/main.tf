### Network resources

resource "aws_vpc" "iac-vpc" {
  cidr_block           = "192.168.42.0/24"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "iac-vpc"
  }
}

resource "aws_subnet" "iac-subnet-public-1" {
  vpc_id                  = aws_vpc.iac-vpc.id
  cidr_block              = "192.168.42.0/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "iac-subnet-public-1"
  }
}

resource "aws_subnet" "iac-subnet-public-2" {
  vpc_id                  = aws_vpc.iac-vpc.id
  cidr_block              = "192.168.42.64/26"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "iac-subnet-public-2"
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

resource "aws_route_table_association" "iac-rtb-association-1" {
  subnet_id      = aws_subnet.iac-subnet-public-1.id
  route_table_id = aws_route_table.iac-rtb-public.id
}

resource "aws_route_table_association" "iac-rtb-association-2" {
  subnet_id      = aws_subnet.iac-subnet-public-2.id
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


### EKS resources

resource "aws_iam_role" "iac-role-eks-cluster" {
  name = "iac-role-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "iac-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iac-role-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "iac-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.iac-role-eks-cluster.name
}

resource "aws_eks_cluster" "iac-eks-cluster" {
  name     = "iac-eks-cluster"
  role_arn = aws_iam_role.iac-role-eks-cluster.arn

  vpc_config {
    subnet_ids = [aws_subnet.iac-subnet-public-1.id, aws_subnet.iac-subnet-public-2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iac-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.iac-AmazonEKSVPCResourceController,
  ]

  tags = {
    Name = "iac-eks-cluster"
  }
}

resource "aws_iam_role" "iac-role-eks-node-group" {
  name = "iac-role-eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "iac-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iac-role-eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "iac-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iac-role-eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "iac-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iac-role-eks-node-group.name
}

resource "aws_eks_node_group" "iac-eks-node-group" {
  cluster_name    = aws_eks_cluster.iac-eks-cluster.name
  node_group_name = "iac-eks-node-group"
  node_role_arn   = aws_iam_role.iac-role-eks-node-group.arn
  subnet_ids      = [aws_subnet.iac-subnet-public-1.id, aws_subnet.iac-subnet-public-2.id]
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.iac-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.iac-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.iac-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "iac-eks-node-group"
  }
}
