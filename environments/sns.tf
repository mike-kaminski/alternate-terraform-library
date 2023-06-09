resource "aws_sns_topic" "waf_alerts" {
  count        = local.enable_cloudwatch_alarm
  name         = "WAF_Rate_Limit"
  display_name = "WAF Rate Limit Alert Topic"
}

resource "aws_sns_topic_subscription" "waf_alert_sub" {
  count                  = local.enable_cloudwatch_alarm
  topic_arn              = aws_sns_topic.waf_alerts[0].arn
  protocol               = "email"
  endpoint               = "devops-notifications-aaaafic7rajuazblbskbg5yiuu@embarkveterinary.slack.com"
  endpoint_auto_confirms = true
}