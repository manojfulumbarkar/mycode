

resource "aws_lb" "my-lb" {
  name                       = "my-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [data.aws_security_group.sg.id]
  subnets                    = data.aws_subnets.public_subnets.ids
  enable_deletion_protection = false

}