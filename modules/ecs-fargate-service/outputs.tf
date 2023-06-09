output "ecs_service_id" {
  description = "ARN of the ECS service."
  value       = aws_ecs_service.service.id
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.service.name
}

output "autoscaling_resource_id" {
  description = "Unique identifier string for the resource associated with the scaling policy."
  value       = aws_appautoscaling_target.service-target.resource_id

}

output "autoscaling_dimension" {
  description = "The scalable dimension of the scalable target."
  value       = aws_appautoscaling_target.service-target.scalable_dimension
}

output "autoscaling_namespace" {
  description = "The AWS service namespace of the scalable target."
  value       = aws_appautoscaling_target.service-target.service_namespace
}

output "dns_alias_name" {
  value = data.aws_lb.lb.dns_name
}

output "record_zone_id" {
  value = data.aws_lb.lb.zone_id
}

output "zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

output "listener_arn" {
  value = data.aws_lb_listener.https.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}