resource "aws_lb" "terralab-lb" {
  name               = "terralab-lb"
  internal           = false
  
#   load_balancer_type is application by default 
security_groups = [aws_security_group.web.id]
  load_balancer_type = "application"
  subnets            = [for subnet in var.public_subnets: subnet]

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "terralab-lb"
#     enabled = true
#   }

  tags = {
    Environment = "dev"
  }
}


resource "aws_lb_target_group" "terralab-public" {
  # ...
  name     = "terra-lb-tg"
  port     = 80
  target_type = "instance"
  protocol = "TCP"
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }
}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.terralab-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    # type             = "forward"
    # target_group_arn = aws_lb_target_group.front_end.arn
      type = "redirect"   


  redirect {
    port = "443"
    protocol = "HTTPS"
    status_code = "HTTP_301"
  }
}
}

resource "aws_security_group" "web" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "terralab web lb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["172.72.200.66/32"]

  }
}