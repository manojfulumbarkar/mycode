
data "template_file" "user_data" {
  template = file("./userdata.sh")

}

data "aws_availability_zones" "az" {
  state = "available"

}