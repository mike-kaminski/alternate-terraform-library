data "aws_caller_identity" "current" {}

data "aws_kms_key" "basic" {
  key_id = "alias/basic-data-kms-key"
}

data "aws_route53_zone" "web_platform" {
  name         = local.route53_public_zone_name
  private_zone = false
}

data "aws_vpc" "vpc_info" {
  id = var.vpc_id
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.vpc_info.id
  filter {
    name   = "tag:subnet-type"
    values = ["public"]
  }
}

data "aws_db_cluster_snapshot" "db_cluster_snapshot" {
  count                 = local.enable_regional_cluster
  db_cluster_identifier = var.db_cluster_identifier
  most_recent           = true
}

data "aws_acm_certificate" "certificate" {
  count       = contains(["prod"], var.environment) ? 1 : 0
  domain      = "*.embarkvet.com"
  most_recent = true
}