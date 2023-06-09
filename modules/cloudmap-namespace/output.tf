output "id" {
  description = "ID of the private namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.id
}