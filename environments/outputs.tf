output "domain_validation_records" {
  value       = flatten(aws_acm_certificate.certificate[*].domain_validation_options)
  description = "Set of domain validation objects which can be used to complete certificate validation."
}
