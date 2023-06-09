resource "aws_db_parameter_group" "db-parameter-group" {
  family = "aurora-mysql5.7"
  name   = "web-platform-database-param-${var.environment}"
  parameter {
    apply_method = "immediate"
    name         = "max_allowed_packet"
    value        = "100000000"
  }
  parameter {
    apply_method = "immediate"
    name         = "net_buffer_length"
    value        = "100000"
  }
}

resource "aws_rds_cluster_parameter_group" "cluster-parameter-group" {
  family      = "aurora-mysql5.7"
  name        = "web-platform-cluster-param-${var.environment}"
  description = "Aurora V2 cluster parameter group for ${var.environment} environment"
  parameter {
    apply_method = "immediate"
    name         = "character_set_client"
    value        = "utf8"
  }
  parameter {
    apply_method = "immediate"
    name         = "character_set_server"
    value        = "utf8"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "lower_case_table_names"
    value        = "1"
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name        = "web-platform-${var.environment}-db-subnet-group"
  subnet_ids  = data.aws_subnet_ids.private_subnets.ids
  description = "Private subnets for ${var.environment} environment"

}