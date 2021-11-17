resource "aws_lb" "trabajo_lb" {
  name               = "trabajo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]
}

resource "aws_lb_target_group" "trabajo_tg" {
  name     = "trabajo-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.vpc_trabajocloud.id
  tags = {
    Name      = "trabajo_lb"
    Terraform = "True"
  }
  depends_on = [aws_lb.trabajo_lb]
}

resource "aws_lb_listener" "trabajo_http" {
  load_balancer_arn = aws_lb.trabajo_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.trabajo_tg.arn
  }

}