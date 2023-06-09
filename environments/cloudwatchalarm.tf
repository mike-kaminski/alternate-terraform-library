resource "aws_cloudwatch_metric_alarm" "wafblocking" {
  count               = local.enable_cloudwatch_alarm
  alarm_name          = "WAF_Rate_Limiting_PROD"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "0"
  datapoints_to_alarm = "1"
  evaluation_periods  = "1"
  treat_missing_data  = "ignore"
  alarm_description   = "Metric alarm to monitor if a rate-limiting event is occurring."
  alarm_actions       = [aws_sns_topic.waf_alerts[0].id]
  ok_actions          = [aws_sns_topic.waf_alerts[0].id]
  period              = 60
  statistic           = "Sum"
  namespace           = "AWS/WAFV2"
  metric_name         = "BlockedRequests"
  dimensions = {
    "Region" = var.region
    "Rule"   = "SelfManagedRulesBlanketHTTPFlood"
    "WebACL" = aws_wafv2_web_acl.wafv2_web_acl.name
  }
}
