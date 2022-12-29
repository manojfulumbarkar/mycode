
# vpc

resource "aws_vpc" "myvpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = null
  enable_dns_support   = null

  tags = {
    "Name" = "pro-vpc"
  }

}

# internet gateways

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    "Name" = "my-igw"
  }

}

# public subnet 

resource "aws_subnet" "pb_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.av.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-subnet-1"
  }

}

resource "aws_subnet" "pb_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.av.names[1]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-2"
  }
}

# private subnet

resource "aws_subnet" "dbs_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.av.names[0]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "database-subnet-1"
  }
}

resource "aws_subnet" "dbs_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.av.names[1]
  map_public_ip_on_launch = false
  tags = {
    "Name" = "database-subnet-2"
  }
}

## route table

resource "aws_route_table" "pbrt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "public-rt"
  }
}

resource "aws_route_table" "dbrt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    "Name" = "database-rt"
  }

}

# route table associations

resource "aws_route_table_association" "pb_rta_1" {
  subnet_id      = aws_subnet.pb_1.id
  route_table_id = aws_route_table.pbrt.id
}

resource "aws_route_table_association" "pb_rta_2" {
  subnet_id      = aws_subnet.pb_2.id
  route_table_id = aws_route_table.pbrt.id

}

resource "aws_route_table_association" "db_rta_1" {
  subnet_id      = aws_subnet.dbs_1.id
  route_table_id = aws_route_table.dbrt.id
}

resource "aws_route_table_association" "db_rta_2" {
  subnet_id      = aws_subnet.dbs_2.id
  route_table_id = aws_route_table.dbrt.id

}

# security group

resource "aws_security_group" "sg" {
  name        = "vpc_pr_sg"
  description = "sg for project vpc allow all traffic"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description = "all traffic"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all traffic"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "project_sg"
  }

}