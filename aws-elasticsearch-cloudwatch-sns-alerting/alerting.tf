data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_metric_alarm" "healthcheck" {
  alarm_name          = "${var.domain} ES Basic Healthcheck"
  alarm_description   = "Alerts if health of cluster is not green (yellow or red)"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Cluster­Status.green"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_actions       = ["${aws_sns_topic.email_alarm.arn}"]

  dimensions = {
    DomainName = "${var.domain}"
    ClientId   = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_sns_topic" "email_alarm" {
  name = "${var.domain}-es-alarm-topic"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}
