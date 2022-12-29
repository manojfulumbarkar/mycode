

data "aws_security_group" "sg" {
  filter {
    name   = "tag:Name"
    values = ["project_sg"]
  }

}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet*"]
  }

}

data "template_file" "user_data" {
  template = file("./user_data.sh")

}

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["pro-vpc"]
  }

}