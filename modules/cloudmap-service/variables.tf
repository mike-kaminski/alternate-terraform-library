variable "namespace_id" {
  type        = string
  description = "Namespace to deploy service records to"
}

variable "ttl" {
  type        = number
  default     = 15
  description = "TTL for service discovery service"
}

variable "service_name" {
  type        = string
  description = "Instance name to assign to the service"
}

variable "service_record_value" {
  type        = string
  description = "Value to assign to the service instance (CNAME for example)"
}
