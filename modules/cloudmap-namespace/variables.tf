variable "name" {
  type        = string
  description = "Name of the service discovery zone"
}

variable "environment" {
  type        = string
  description = "Environment this is supporting"
}

variable "vpc_id" {
  type        = string
  description = "VPC to configure the private namespace in"
}