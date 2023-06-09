
resource "aws_rds_cluster" "aurora-cluster" {
  apply_immediately                     = true
  availability_zones              = values(data.aws_subnet.subnet-private).*.availability_zone
  backup_retention_period         = 5
  cluster_identifier              = "web-platform-${var.environment}-regional-cluster"
  copy_tags_to_snapshot           = false
  kms_key_id                      = data.aws_kms_key.basic.arn
  global_cluster_identifier       = var.global_cluster_identifier
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster-parameter-group.id
  db_subnet_group_name            = aws_db_subnet_group.db-subnet-group.id
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery",
  ]
  enable_http_endpoint         = false
  engine                       = "aurora-mysql"
  engine_mode                  = "provisioned"
  engine_version               = "5.7.mysql_aurora.2.09.2"
  port                         = 3306
  preferred_backup_window      = "20:00-21:00"
  preferred_maintenance_window = "thu:02:00-thu:02:30"
  skip_final_snapshot          = true
  storage_encrypted            = true
  vpc_security_group_ids       = [aws_security_group.db-sg.id]
  snapshot_identifier          = var.db_cluster_identifier
  timeouts {}
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
      global_cluster_identifier,
      snapshot_identifier,
    ]
  }
}
resource "aws_rds_cluster_instance" "cluster_instance" {
  apply_immediately                     = true
  count                      = var.count_instances
  auto_minor_version_upgrade = true
  ca_cert_identifier         = "rds-ca-2019"
  cluster_identifier         = aws_rds_cluster.aurora-cluster.id
  copy_tags_to_snapshot      = false
  db_parameter_group_name    = aws_db_parameter_group.db-parameter-group.id
  db_subnet_group_name       = aws_db_subnet_group.db-subnet-group.id
  engine                     = aws_rds_cluster.aurora-cluster.engine
  engine_version             = aws_rds_cluster.aurora-cluster.engine_version
  identifier                 = "web-platform-${var.environment}-instance-${count.index + 1}"
  instance_class             = var.db_instance_class
  promotion_tier             = 1

  timeouts {}
}
