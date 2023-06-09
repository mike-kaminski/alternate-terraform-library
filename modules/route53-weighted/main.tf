locals {
  weighted = var.weighted ? [""] : []
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = var.public_domain
  type    = "A"

  dynamic "weighted_routing_policy" {
    for_each = local.weighted
    content {
      weight = var.record_weight
    }
  }

  set_identifier = var.weighted ? var.environment : null
  
  alias {
    name                   = var.dns_alias_name
    zone_id                = var.record_zone_id
    evaluate_target_health = true
  }
}

variable zone_id {
  type        = string
  description = "DNS zone to create the record in"
}


variable record_weight {
  type        = number
  default     = 50
  description = "Weight of routing policy record"
}


variable record_zone_id {
  type        = string
  description = "DNS Zone ID for the DNS record alias"
}


variable dns_alias_name {
  type        = string
  description = "Alias for the DNS record"
}


variable public_domain {
  type        = string
  description = "Public DNS zone to deploy records to"
}

variable weighted {
  type        = bool
  default     = false
  description = "Whether to create weighted records or normal records"
}

variable environment {
  type        = string
  description = "Application environment"
}