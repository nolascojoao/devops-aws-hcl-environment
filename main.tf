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

# Para gerar um par de chaves SSH, use o comando:
# ssh-keygen -t ed25519 -f ~/.ssh/my-key
# Isso criará a chave privada (~/.ssh/my-key) e a chave pública (~/.ssh/my-key.pub).
# A chave pública será usada no recurso abaixo.
resource "aws_key_pair" "ec2_auth" {
    key_name = "my-key"
    public_key = file("~/.ssh/my-key.pub")
}

resource "aws_instance" "devops_ec2" {
  instance_type = "t2.micro"
  ami = data.aws_ami.server_ami.id
  key_name = aws_key_pair.ec2_auth.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  subnet_id = aws_subnet.public-subnet-01.id
  associate_public_ip_address = true
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "devops-ec2"
  }
}