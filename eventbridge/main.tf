resource "aws_cloudwatch_event_rule" "event" {
  name          = "MyEC2StateChangeEvent"
  description   = "MyEC2StateChangeEvent"

  
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["pending", "shutting-down", "terminated", "stopped"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "sns-target"
  arn       = var.sns_arn
}