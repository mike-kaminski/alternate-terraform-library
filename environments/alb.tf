resource "aws_lb" "lb" {
  name               = "web-platform-${var.environment}-private"
  load_balancer_type = "application"
  internal           = true

  subnets = data.aws_subnet_ids.private_subnets.ids

  security_groups = [aws_security_group.allow-internal.id, aws_security_group.allow-external.id]
}

resource "aws_security_group" "allow-internal" {
  description = "Allows all traffic within the VPC"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = [data.aws_vpc.vpc_info.cidr_block]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = [data.aws_vpc.vpc_info.cidr_block]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  name   = "web-platform-${var.environment}_allow-internal"
  vpc_id = data.aws_vpc.vpc_info.id
}

resource "aws_security_group" "allow-external" {
  description = "Allows external https traffic"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name   = "${var.environment}_allow-external"
  vpc_id = data.aws_vpc.vpc_info.id
}

resource "aws_lb_listener" "lb_listener_redirect_80_to_443" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_listener_443" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "400"
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.lb.arn
  web_acl_arn  = aws_wafv2_web_acl.wafv2_web_acl.arn
}

resource "aws_lb_listener_certificate" "certificate" {
  count           = contains(["uat", "prod", "prod-dr"], var.environment) ? 1 : 0
  listener_arn    = aws_lb_listener.lb_listener_443.arn
  certificate_arn = var.environment == "prod" ? data.aws_acm_certificate.certificate[0].arn : aws_acm_certificate.certificate[0].arn
}