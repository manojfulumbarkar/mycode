
## launch configuration

resource "aws_launch_configuration" "lc" {
  name_prefix   = "as-lc"
  image_id      = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered
  # user data file should be created in same folder
  key_name                    = "newkey"
  associate_public_ip_address = true
  security_groups             = [data.aws_security_group.sg.id]

}

## target group

resource "aws_lb_target_group" "tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id

}

## listner

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

}

## autoscaling group

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  vpc_zone_identifier  = data.aws_subnets.public_subnets.ids
  min_size             = "2"
  max_size             = "4"
  desired_capacity     = "2"
  launch_configuration = aws_launch_configuration.lc.name
  target_group_arns    = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "w/p_app_server"
    propagate_at_launch = true
  }

  depends_on = [
    aws_lb_target_group.tg
  ]
}

