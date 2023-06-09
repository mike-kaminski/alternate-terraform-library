variable "container_version" {
  description = " Container image version"
}

variable "cpu_target_threshold" {
  default     = "80"
  description = "CPU target percentage to trigger autoscale"
}

variable "cpu" {
  default     = 512
  type        = number
  description = "Number of cpu units used by the task"
}

variable "ecs_cluster" {
  default     = null
  description = "ECS Cluster name to deploy the service"
}

variable "environment" {
  default     = ""
  description = "Environment for deployment"
}

variable "dns_zone" {
  default     = "embarkvet.com"
  description = "DNS Zone to create record"
}

variable "health_check_path" {
  default     = ""
  description = "Service health endpoint to check"
}

variable "lb_name" {
  default     = ""
  description = "ALB name to configure the listerner"
}

variable "memory_target_threshold" {
  default     = "80"
  description = "Memory target percentage to trigger autoscale"
}

variable "memory" {
  default     = 1024
  type        = number
  description = "Amount (in MiB) of memory used by the task"
}

variable "path" {
  default     = "/*"
  description = "Path to configure the alb listener"
}

variable "port" {
  default     = 8080
  type        = number
  description = "Port the application runs on"
}

variable "project" {
  default     = ""
  description = "Project, aka the application name"
}

variable "region" {
  default     = ""
  description = "AWS region for resources"
}

variable "replicas" {
  default     = "1"
  description = "Number of containers (instances) to run"
}

variable "source_ecr_repo" {
  default     = ""
  description = "Source ECR repository for container image"  
}

variable "task_iam_policy" {
  default     = ""
  description = "Policy document for ecs task"
}

variable "vpc_id" {
  default     = ""
  description = "VPC ID to use for the resources"
}

variable "app_definitions" {
  default     = ""
  description = "Map of environment variables for the application"
}

variable "deployment_maximum_percent" {
  default     = "200"
  description = "Max percentage of the service's desired count during deployment"
}

variable "deployment_minimum_healthy_percent" {
  default     = "100"
  description = "Min percentage of the service's desired count during deployment"
}

variable "health_check_grace_period_seconds" {
  default     = "120"
  description = "Seconds to ignore failing load balancer health checks on new tasks"
}

variable "platform_version" {
  default     = "1.4.0"
  description = "Platform version on which to run your service."
}

variable "autoscale_min_capacity" {
  default     = "1"
  description = "The min capacity for autoscaling"
}

variable "autoscale_max_capacity" {
  default     = "5"
  description = "The max capacity for autoscaling"
}

variable "public_domain" {
  default     = ""
  description = "Public full domain to access the application"
}
