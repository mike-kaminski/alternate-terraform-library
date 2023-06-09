data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_kms_key" "basic" {
  key_id = "alias/basic-data-kms-key"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:SUB-Type"
    values = ["Private"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:SUB-Type"
    values = ["Public"]
  }
}

data "aws_lb" "lb" {
  name = var.lb_name
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.lb.arn
  port              = 443
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.ecs_cluster
}

data "aws_availability_zones" "zones" {
  state = "available"
}

data "aws_route53_zone" "selected" {
  name = "${var.environment}.${var.dns_zone}"
}

data "aws_route53_zone" "cloudmap" {
  name         = "embarkvet.local"
  private_zone = true
  vpc_id       = var.vpc_id
}