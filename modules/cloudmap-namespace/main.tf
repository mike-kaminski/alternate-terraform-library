resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = var.name
  description = "Private service discovery zone for ${var.environment}"
  vpc         = var.vpc_id
}