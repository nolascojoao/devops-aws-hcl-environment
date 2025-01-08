resource "aws_vpc" "vpc-01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops"
  }
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "devops-public"
  }
}

resource "aws_internet_gateway" "IGW-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_route_table" "public-rt-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "devops-public-rt-01"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public-rt-01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW-01.id
}

resource "aws_route_table_association" "public-subnet-01-assoc" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public-rt-01.id
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Security Group for DevOps"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Troque 0.0.0.0/0 pelo seu IP /32
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
