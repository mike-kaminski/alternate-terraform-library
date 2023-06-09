variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "db_instance_class" {
  type = string

}

variable "global_cluster_identifier" {
  type    = string
  default = ""
}

variable "count_instances" { default = "" }
variable "db_cluster_identifier" { default = "" }


