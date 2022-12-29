

data "aws_subnets" "available_database_subnets" {

  filter {
    name   = "tag:Name"
    values = ["database*"] ### * it will take all subnet starting name with database
  }

}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["pro-vpc"]
  }

}

data "aws_security_group" "db-sg" {
  filter {
    name   = "tag:Name"
    values = ["project_sg"]
  }

}