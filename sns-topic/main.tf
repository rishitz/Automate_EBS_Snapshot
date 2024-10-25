provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "topic" {
  name = "ebs-snpshot-topic"

  lambda_success_feedback_sample_rate = 100
  lambda_success_feedback_role_arn    = "arn:aws:iam::924144197303:role/SNSSuccessFeedback_1729766932176"
  lambda_failure_feedback_role_arn    = "arn:aws:iam::924144197303:role/SNSFailureFeedback_1729766932176"
}

resource "aws_sns_topic_subscription" "this" {
  for_each =  var.sns_subscriptions
  topic_arn = aws_sns_topic.topic.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint

}
