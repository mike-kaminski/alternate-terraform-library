resource "aws_ecs_cluster" "cluster" {
  name = "web-platform-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  capacity_providers = ["FARGATE", ]
}