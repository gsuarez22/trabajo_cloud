resource "aws_vpc" "vpc_trabajocloud" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name        = "vpc_trabajocloud"
    Terraform   = "True"
    Description = "VPC for trabajo en clase"
  }
}

resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.vpc_trabajocloud.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "subnet-public-1"
    Terraform   = "True"
    Description = "Subnet for tarea clase"
  }
}
resource "aws_subnet" "subnet_public_2" {
  vpc_id                  = aws_vpc.vpc_trabajocloud.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "us-east-1e"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "subnet-public-2"
    Terraform   = "True"
    Description = "Subnet for tarea clase"
  }
}



resource "aws_internet_gateway" "gateway_tareacloud" {
  vpc_id = aws_vpc.vpc_trabajocloud.id
  tags = {
    Name        = "gateway_tareacloud"
    Terraform   = "True"
    Description = "Gateway for the tarea clase"
  }
}

resource "aws_default_route_table" "defaultroutetable_tareacloud" {
  default_route_table_id = aws_vpc.vpc_trabajocloud.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_tareacloud.id
  }
  tags = {
    Name        = "defaultroutetable_tareacloud"
    Terraform   = "True"
    Description = "Route Table for tarea cloud"
  }
} 