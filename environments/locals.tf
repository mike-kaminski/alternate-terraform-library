locals {
  route53_public_zone_name  = "${var.environment}.embarkvet.com"
  route53_private_zone_name = "embarkvet.local"
  enable_cloudwatch_alarm   = contains(["prod"], var.environment) ? 1 : 0
}
