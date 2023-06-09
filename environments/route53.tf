resource "aws_route53_zone" "web_platform_public" {
  name = local.route53_public_zone_name
}

resource "aws_route53_zone" "web_platform_private" {
  name = local.route53_private_zone_name
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }
}