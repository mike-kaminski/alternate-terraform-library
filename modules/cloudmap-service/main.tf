resource "aws_service_discovery_service" "service" {
  name = var.service_name
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = var.ttl
      type = "CNAME"
    }
    routing_policy = "WEIGHTED"
  }
}

resource "aws_service_discovery_instance" "service" {
  instance_id = var.service_name
  service_id  = aws_service_discovery_service.service.id

  attributes = {
    AWS_INSTANCE_CNAME = var.service_record_value
  }
}
