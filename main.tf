resource "aws_vpc" "vpc-01" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "devops"
    }
}

resource "aws_subnet" "public-subnet-01" {
    vpc_id = aws_vpc.vpc-01.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

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