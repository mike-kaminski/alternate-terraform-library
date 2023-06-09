output "cluster-arn" {
  value = aws_rds_cluster.aurora-cluster.arn
}

output "cluster_endpoint" {
  value = aws_rds_cluster.aurora-cluster.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.aurora-cluster.reader_endpoint
}